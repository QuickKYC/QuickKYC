<?php
class Form extends AppModel
{
	var $useTable = 'form';
	
	var $belongsTo = array(
			'Merchant' => array(
					'className' => 'Merchant',
					'foreignKey' => 'm_id'
			)
	);
	
	var $hasMany = array(
			'FormKey' => array(
					'className' => 'FormKey',
					'foreignKey' => 'fid'
			)		
	);
	
	/*public $hasAndBelongsToMany = array(
			'FormKey' => array(
					'className' => 'FormKey',
					'joinTable' => 'form_keys',
					'foreignKey' => 'fid',
					'associationForeignKey' => 'id',
					'unique' => true,
					'conditions' => '',
					'fields' => '',
					'order' => '',
					'limit' => '',
					'offset' => '',
					'finderQuery' => '',
					'deleteQuery' => '',
					'insertQuery' => ''
			),
	);*/
}
?>