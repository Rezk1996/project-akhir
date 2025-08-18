package com.boniewijaya2021.springboot.service;

import com.boniewijaya2021.springboot.entity.TblSales;
import com.boniewijaya2021.springboot.entity.User;
import com.boniewijaya2021.springboot.pojo.UsersPostPojo;
import com.boniewijaya2021.springboot.repository.SalesRepository;
import com.boniewijaya2021.springboot.repository.UserRepository;
import com.boniewijaya2021.springboot.utility.MessageModel;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;

import java.util.HashMap;
import java.util.Map;

@Service
public class SalesPostService {

    @Autowired
    private SalesRepository salesRepository;

    @Autowired
    private UserRepository userRepository;

    public ResponseEntity<MessageModel> addDataPenjualan(TblSales tblSales)
    {
        Map<String, Object> result = new HashMap<>();
        MessageModel msg = new MessageModel();

        try{
            salesRepository.save(tblSales);
            msg.setStatus(true);
            msg.setMessage("Success");
            result.put("data", tblSales);
            msg.setData(result);
            return ResponseEntity.status(HttpStatus.OK).body(msg);

        }catch (Exception e){
            e.printStackTrace();
            msg.setStatus(false);
            msg.setMessage(e.getMessage());
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body(msg);
        }
    }

    public ResponseEntity<MessageModel> addDataUsers(UsersPostPojo usersPostPojo)
    {
        Map<String, Object> result = new HashMap<>();
        MessageModel msg = new MessageModel();


        try{
            User user = new User();
            user.setName(usersPostPojo.getSalesName());
            user.setEmail(usersPostPojo.getEmail());
            user.setPassword("default123"); // Set default password
            userRepository.save(user);
            msg.setStatus(true);
            msg.setMessage("Success");
            result.put("data", user);
            msg.setData(result);
            return ResponseEntity.status(HttpStatus.OK).body(msg);

        }catch (Exception e){
            e.printStackTrace();
            msg.setStatus(false);
            msg.setMessage(e.getMessage());
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body(msg);
        }
    }
}
