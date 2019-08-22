import hashlib
import json
from time import time
from uuid import uuid4
from textwrap import dedent
from urllib.parse import urlparse

from flask import Flask, jsonify, request
import requests
import sys

class Blockchain(object):
	def __init__(self):
		self.chain = []
		self.current_transactions = []
		self.new_block(previous_hash=1, proof=100)
		self.nodes = set()

	def new_block(self, proof, previous_hash=None,):
		block = {
			'index': len(self.chain) + 1,
			'timestamp': time(),
			'transactions': self.current_transactions,
			'proof': proof,
			'previous_hash': previous_hash or self.hash(self.last_block), 
		}
		self.current_transactions = []
		self.chain.append(block)
		return block

	def new_transaction(self, sender, recipient, amount):
		self.current_transactions.append({
			'sender': sender,
			'recipient': recipient,
			'amount': amount
		})
		return self.last_block['index'] + 1

	def register_node(self, address):
		parsed_url = urlparse(address)
		self.nodes.add(parsed_url.netloc)

	def valid_chain(self, chain):
		last_block = chain[0]
		index = 1

		while index < len(chain):
			block = chain[index]

			if block['previous_hash'] != self.hash(last_block):
				return False

			if not self.valid_proof(last_block['proof'], block['proof']):
				return False

			index += 1
			last_block = block

		return True

	def resolve_conflicts(self):
		neighbours = self.nodes
		new_chain = None
		max_len = len(self.chain)

		for node in neighbours:
			response = requests.get(f'http://{node}/chain')

			if response.status_code == 200:
				length = response.json()['length']
				chain = response.json()['chain']

				if length > max_len and self.valid_chain(chain):
					new_chain = chain
					max_len = length

		if new_chain:
			self.chain = new_chain
			return True

		return False


	@staticmethod
	def hash(block):
		block_chain = json.dumps(block, sort_keys=True).encode()
		return hashlib.sha256(block_chain).hexdigest()

	@property
	def last_block(self):
		return self.chain[-1]

	def proof_of_work(self, last_proof):
		proof = 0
		while self.valid_proof(last_proof, proof) is False:
			proof += 1

		return proof

	@staticmethod
	def valid_proof(prev_proof, new_proof):
		guess = f'{prev_proof}{new_proof}'.encode()
		guess_hash = hashlib.sha256(guess).hexdigest()
		return guess_hash[ :4] == '0000'


app = Flask(__name__)

node_identifier = str(uuid4()).replace('-', '')

blockchain = Blockchain()


@app.route('/mine', methods=['GET'])
def mine():
	last_block = blockchain.last_block
	proof = blockchain.proof_of_work(last_block['proof'])

	blockchain.new_transaction(sender=0, recipient=node_identifier, amount=1)

	previous_hash = blockchain.hash(last_block)
	block = blockchain.new_block(proof=proof, previous_hash=previous_hash)

	response = {
		'message': 'New Block forged',
		'index': block['index'],
		'transactions': block['transactions'],
		'proof': block['proof'],
		'previous_hash': block['previous_hash']
	}
	return jsonify(response), 200

@app.route('/transactions/new', methods=['POST'])
def new_transaction():
	values = request.get_json()
	required = ['sender', 'recipient', 'amount']
	if not all(v in values for v in required):
		return 'Missing values', 400

	index = blockchain.new_transaction(values['sender'], values['recipient'], values['amount'])
	response = {'message': f'Transaction will be added to Block {index}'}
	return jsonify(response)

@app.route('/chain', methods=['GET'])
def full_chain():
	response = {
		'chain': blockchain.chain,
		'length': len(blockchain.chain)
	}
	return jsonify(response), 200

@app.route('/chain/register', methods=['POST'])
def register_nodes():
	values = request.get_json()
	nodes = values['nodes']

	if not nodes:
		return 'Error: Please supply valid nodes', 400

	for node in nodes:
		blockchain.register_node(node)

	response = {
		'message': 'Nodes registered!',
		'total_nodes': list(blockchain.nodes)
	}
	return jsonify(response), 201

@app.route('/chain/resolve', methods=['GET'])
def consensus():
	status = blockchain.resolve_conflicts()
	if status:
		response = {
			'message': 'Chain updated!',
			'new_chain': blockchain.chain
		}
	else:
		response = {
			'message': 'Chain authoritative!',
			'chain': blockchain.chain
		}
	return jsonify(response), 200


if __name__ == '__main__':
	app.run(host='127.0.0.1', port=sys.argv[1])