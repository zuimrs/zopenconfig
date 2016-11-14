#!/usr/bin/python
# -*- coding: utf-8 -*-
import sys
import os
import keystoneclient.v2_0.client as ksclient

def get_keystone_creds():
	d = {}
	d['username'] = os.environ['OS_USERNAME']
	d['password'] = os.environ['OS_PASSWORD']
	d['auth_url'] = os.environ['OS_AUTH_URL']
	d['tenant_name'] = os.environ['OS_TENANT_NAME']
	return d

def get_nova_creds():
	d = {}
	d['username'] = os.environ['OS_USERNAME']
	d['api_key'] = os.environ['OS_PASSWORD']
	d['auth_url'] = os.environ['OS_AUTH_URL']
	d['project_id'] = os.environ['OS_TENANT_NAME']
	return d

def authentication():
	d = get_keystone_creds();
	keystone = ksclient.Client(auth_url=d['auth_url'] , username=d['username'] ,
                               password=d['password'] ,tenant_name=d['tenant_name'] )
	return keystone

if __name__=='__main__':
	keystone = authentication()
	if sys.argv[1]=="role_add":
		keystone.roles.create(os.environ['ROLE_NAME'])
		keystone.roles.list()
	elif sys.argv[1]=="role_delete":
		print("do delete")
	elif sys.argv[1]=="role_clean":
		print("do clean")
	elif sys.argv[1]=="user_add":
		if os.environ['USER_TENANT_ID']=='None':
			default_id=None
		else:
			default_id=os.environ['USER_TENANT_ID']
		keystone.users.create(name=os.environ['USER_NAME']
			,password=os.environ['USER_PASSWORD']
			,email=os.environ['USER_EMAIL']
			,tenant_id=default_id)
	elif sys.argv[1]=="user_delete":
		print("do delete")
	elif sys.argv[1]=="user_clean":
		print("do clean")
	elif sys.argv[1]=="tenant_add":
		if os.environ['TENANT_ENABLED']=='True' or os.environ['TENANT_ENABLED']=='Default':
			boolen=True
		else:
			boolen=False
		keystone.tenants.create(tenant_name=os.environ['TENANT_NAME']
			,description=os.environ['TENANT_DESCRIPTION']
			,enabled=boolen)
	elif sys.argv[1]=="tenant_delete":
		print("do delete")
	elif sys.argv[1]=="tenant_clean":
		print("do clean")
	'''
	try:
		if sys.argv[1]=="role_add":
			keystone.roles.create(os.environ['ROLE_NAME'])
			keystone.roles.list()
		elif sys.argv[1]=="role_delete":
			print("do delete")
		elif sys.argv[1]=="role_clean":
			print("do clean")
		elif sys.argv[1]=="user_add":
			keystone.users.create(name=os.environ['USER_NAME'])
		elif sys.argv[1]=="user_delete":
			print("do delete")
		elif sys.argv[1]=="user_clean":
			print("do clean")
		elif sys.argv[1]=="tenant_add":
			keystone.tenant.create(name=os.environ['TENANT_NAME']
				,description=os.environ['TENANT_DESCRIPTION']
				)
	except:
		print("Operate " +sys.argv[1]+" Failed")
	'''


