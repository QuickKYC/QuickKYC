<?php
class Qkkey extends AppModel
{
	var $useTable = 'qk_keys';
	
	var $hasMany = array(
			'Qkkeyvalue' => array(
					'className' => 'Qkkeyvalue',
					'foreignKey' => 'qk_id'
			)
	);
}