<?php
App::uses('QrCodeHelper', 'View/Helper');

class FormController extends AppController
{
	var $uses = array('Form','Qkkey','Merchant','Validatedoc');
	

	function beforeFilter()
	{
		if($this->Session->read('isLoggedIn') != '1')
		{
			//$this->redirect(array('controller' => 'home'));
		}
	}
	
	function index()
	{
		$this->layout = "homes";
	}
	
	function dashboard()
	{
		$this->layout = "homes";
	}
	
	function viewform()
	{
		$this->layout = "homes";
		$data = $this->request->data;
		if(empty($data))
		{
			$data = array();
			$data['Form']['fid'] = "2";
			
		}
		if(!empty($data))
		{
			$merchantId = $this->Session->read('merchantId');
			$fId = $data['Form']['fid'];
			$form_data = $this->Form->find("first", array('conditions'=>array('Form.m_id'=>$merchantId)));
			$json_data = array();
			$json_data["fid"] = $form_data['Form']['id'];
			$json_data["name"] = $form_data['Form']['name'];
			$json_data["merchant_url"] = $form_data['Merchant']['ms_url'];
			$json_data["mname"] = $form_data['Merchant']['name'];
			$form_details = array();
			$i = 0;
			foreach ($form_data['FormKey'] as $fDetails)
			{
				$option = 0;
				if($fDetails['option'] == 1)
				{
					$option = 1;
				}
				
				$form_details[$i]['qkid'] = $fDetails['qk_id'];
				$form_details[$i]['optional'] = $option;
				$form_details[$i]['minlen'] = $fDetails['minlength'];
				$i++;
			}
			$json_data["qk_keys"] = $form_details;
			$json_data = json_encode($json_data);
			$this->set('qkkeys', $this->getQkkeys());
			$this->set('formdata', $form_data);
			$this->set('jsondata', $json_data);
		}
	}
	
	function uploadverifieddocs()
	{
		
	}
	
	function getQkkeys()
	{
		$qkkeys = $this->Qkkey->find('all');
		$temp_array = array();
		foreach ($qkkeys as $key)
		{
			$k = $key['Qkkey']['id'];
			$temp_array[$k]['name'] = $key['Qkkey']['name'];
			$temp_array[$k]['type'] = $key['Qkkey']['type'];
			$temp_array[$k]['category'] = $key['Qkkey']['category'];
			$temp_array[$k]['options'] = $key['Qkkeyvalue'];
		}
		return $temp_array;
	}
	
	function verifydocuments()
	{
		$response = array();
		$this->autoRender = false;
		$this->layout = false;
		
		
		$data = $this->request->data;
		$secretkey = $data['serverkey'];
		
		$employeeCheck = $this->Merchant->find('first', array('conditions'=>array('Merchant.m_key'=>$secretkey)));
		if(!empty($employeeCheck))
		{
			$tArray = array();
			foreach ($data['qk_docs'] as $eCheck)
			{
				array_push($tArray, $eCheck['md5']);
			}
			$validatorArray = $this->Validatedoc->find('all', array('conditions'=>array('Validatedoc.md5'=>$tArray,'Validatedoc.mid'=>$employeeCheck['Merchant']['id'])));
			
			
			$i = 0;
			foreach ($validatorArray as $vArray)
			{
				$response[$i]['md5'] = $data["qk_docs"][$i]["md5"];   
				$response[$i]['mid'] = $employeeCheck['Merchant']['id'];  
				$i++;	
			}
			$response["sharedata"] = $response;
			$response["status"] = "success";
			$response["message"] = "";
			
		}
		return $response;
	}
}