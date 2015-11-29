<?php
class LoginController extends AppController
{
	var $uses = array('Merchant');
	public $helpers = array('Session');
	
	function index()
	{
		$this->layout = 'homes';
	}
	
	function login()
	{
		$this->layout = 'homes';
		if(!empty($this->request->data))
		{
			$email = $this->request->data['Login']['email'];
			$password = $this->request->data['Login']['password'];
			$merchant_details = $this->Merchant->find('first', array('conditions' => array('Merchant.email' =>$email, 'Merchant.password' => $password)));
			if(!empty($merchant_details))
			{
				$this->Session->write('merchantId', $merchant_details['Merchant']['id']);
				$this->Session->write('merchantName', $merchant_details['Merchant']['name']);
				$this->Session->write('merchantEmail', $merchant_details['Merchant']['email']);
				$this->Session->write('isLoggedIn', $merchant_details['Merchant']['id']);
				$this->Session->write('isLoggedIn', '1');
				$this->redirect(array('controller' => 'form', 'action' => 'viewform'));
			}
			else
			{
				$this->redirect(array('controller' => 'home'));
			}
		}
		else
		{
			$this->redirect(array('controller' => 'home'));
		}
	}
	
	function dashboard()
	{
		$this->layout = 'homes';
		$this->log($this->Session->read('merchantId'));
	}
	
	function view_form()
	{
		$this->layout = 'homes';
	}
	
	function logout()
	{
		$this->layout = false;
		$this->autoRender = false;
		$this->Session->write('isLoggedIn', '0');
		$this->Session->destroy();
		$this->redirect(array('controller' => 'home'));
	}
}