<?php
class MerchantController extends AppController
{
	public $uses = array('Formtransaction','Employee');

	function index()
	{
		$this->layout = 'homes';
	}
	
	function login()
	{
		$this->layout = false;
		$this->autoRender = false;
		
		$response = array();
		$response['status'] = "failure";
		$response['message'] = "";
		$data = $this->request->data;
		if (!empty($data))
		{
			$data = $this->jsonToArray($data);
			$this->log($data);
			if(!empty($data))
			{
				$userId = $data['userid'];
				$password = $data['password'];
				$deviceId =  $data['deviceid'];
				$deviceType =  $data['devicetype'];
				
				$emp_details = $this->Employee->find('first', array('conditions'=>array('Employee.uname'=>$userId, 'Employee.password'=>$password)));
				
				if(!empty($emp_details))
				{
					$temp_array = array();
					$temp_array['id'] = $emp_details['Employee']['id'];
					$temp_array['deviceid'] = $deviceId;
					$temp_array['devicetype'] = $deviceType;
					$this->Employee->saveAll($temp_array);
					$response['status'] = "success";
					$response['id'] = $emp_details['Employee']['id'];
					$this->Session->write('isLoggedIn', '1');
				}
				else
				{
					$response['status'] = "failure";
				}
			}
			else 
			{
				$response['status'] = "failure";
			}
		}
		else
		{
			$response['status'] = "failure";
		}
		
		$response = json_encode($response);
		return $response;
	}
	
	function validateform()
	{
		$this->layout = false;
		$this->autoRender = false;
	
		$response = array();
		$response['status'] = "failure";
		$response['message'] = "";
		$data = $this->request->data;
		if (!empty($data))
		{
			$data = $this->jsonToArray($data);
			$this->log($data);
			if(!empty($data))
			{
				$refid = $data["refid"];
				$empid = $data["empid"];
				if(count($data["qk_docs"] > 0))
				{
					$data['serverkey'] = "abc123";
					$postdata = http_build_query($data);
					
					$opts = array('http' =>
							array(
									'method'  => 'POST',
									'header'  => 'Content-type: application/x-www-form-urlencoded',
									'content' => $postdata
							)
					);
					
					$context  = stream_context_create($opts);
					$result = file_get_contents('http://localhost/QuickKYC/quickkyc/form/uploadverifieddocs', false, $context);
					$this->log("Response from FORMCONTROLLER");
					$this->log($result);
				}
				
				$response['status'] = "success";
			}
			else
			{
				$response['status'] = "failure";
			}
		}
		else
		{
			$response['status'] = "failure";
		}
	
		$response = json_encode($response);
		return $response;
	}
	
	function submitform()
	{
		$this->layout = false;
		$this->autoRender = false;
		
		$response = array();
		$response['status'] = "failure";
		$response['message'] = "";
		$data = $this->request->data;
		$this->log("Subbbbbbbmit");
		$this->log($data);
		if (!empty($data))
		{
			$data = $this->jsonToArray($data);
			if(!empty($data))
			{
				$containsDocument = false;
				if(count($data["qk_docs"]) > 0)
				{
					if (array_key_exists($data["qk_docs"][0]["mid"], $data["qk_docs"])) 
					{
						$containsDocument = true;
					}
				}
				
				$temp_array = array();
				$temp_array['Formtransaction']['eid'] = '1';
				$temp_array['Formtransaction']['isverified'] = '0';
				
				$this->Formtransaction->saveAll($temp_array);
				$id = $this->Formtransaction->getLastInsertID();
				
				if($containsDocument)
				{
					$i = 0;
					$temp_data = array();
					foreach ($data["qk_docs"] as $qDocs)
					{
						$temp_data[$i]["md5"] = "MD5";
						$temp_data[$i]["mid"] = $qDocs["mid"];
						
						$i++;
					}
					$temp_data_1["qk_docs"] = $temp_data; 
					$temp_data_1["serverkey"] = "abc123";
					
					$this->log("Temp Data values");
					$this->log($temp_data_1);
					
					$postdata = http_build_query($temp_data_1);
						
					$opts = array('http' =>
							array(
									'method'  => 'POST',
									'header'  => 'Content-type: application/x-www-form-urlencoded',
									'content' => $postdata
							)
					);
						
					$context  = stream_context_create($opts);
					$result = file_get_contents('http://localhost/QuickKYC/quickkyc/form/verifydocuments', false, $context);
					$this->log("Response from FORMCONTROLLER");
					$this->log($result);
				}
				
				unset($data["fid"]);
				
				$data["refid"] = $id;
				$this->log("DATAAAA");
				$this->log($data);
				
				$j = 0;
				foreach ($data['qk_docs'] as $res)
				{
					$res['comment'] = $result[$j]['comment'];
					$res['mname'] = $result[$j]['mname'];
					$res['verified'] = $result[$j]['verified'];
					$j++;
				}
				
				$this->storeFile(json_encode($data), $id);
				$response['status'] = "success";
			}
			else
			{
				$response['status'] = "failure";
			}
		}
		else
		{
			$response['status'] = "failure";
		}
		
		$response = json_encode($response);
		return $response;
	}
	
	function storeFile($str, $folder_id)
	{
		$this->log($str);
		$dir = WWW_ROOT.'upload_folder/'.$folder_id;
		if(!is_dir($dir))
		{
			mkdir($dir, 0777, true);
		}
		$file_path = $dir.'/'.$folder_id.'.txt';
		$file_path = fopen($file_path, 'w');
		fwrite($file_path, $str);
		fclose($file_path);
	}
	
	function getallform()
	{
		$this->layout = false;
		$this->autoRender = false;
		
		$response = array();
		$data = $this->request->data;
		$this->log($data);
		if (!empty($data))
		{
			$data = $this->jsonToArray($data);
			if(!empty($data))
			{
				$emp_id = $data["id"];
				$formDetails = $this->Formtransaction->find('all', array('conditions'=>array('Formtransaction.eid'=>$emp_id, 'Formtransaction.isverified'=>0)));
				if(!empty($formDetails))
				{
					$temp_array = array();
					foreach ($formDetails as $fDetails)
					{
						array_push($temp_array, $fDetails['Formtransaction']['id']);
					}
					
					$this->log($temp_array);
					$response = $temp_array;
				}
			}
		}
		
		$response = json_encode($response);
		return $response;
	}
	
	function getform()
	{
		$this->layout = false;
		$this->autoRender = false;
		$data = $this->request->data;
		if (!empty($data))
		{
			$data = $this->jsonToArray($data);
			if(!empty($data))
			{
				$folder_id = $data["id"];
				$folder_id = "1";
				
				$dir = WWW_ROOT.'upload_folder/'.$folder_id;
				$file_path = $dir.'/'.$folder_id.'.txt';
				$file_path_2 = $file_path;
				$file_path = fopen($file_path, 'r');
				$str = fread($file_path,filesize($file_path_2));
				fclose($file_path);
			}
		}
		
		$this->log($str);
	
		return $str;
	}

}