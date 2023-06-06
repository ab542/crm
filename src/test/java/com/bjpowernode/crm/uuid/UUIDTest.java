package com.bjpowernode.crm.uuid;

import java.util.UUID;

public class UUIDTest {
    public static void main(String[] args) {
        String s = UUID.randomUUID().toString();
        System.out.println(s);//3e2e8dd3-7bc2-40db-a284-f5436470dd08
        System.out.println(s.replaceAll("-",""));
    }
}
