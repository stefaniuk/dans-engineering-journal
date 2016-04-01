---
layout: post
title: "How to Configure Apigility with Doctrine and QueryBuilder"
date: 2016-03-28 23:17:00 +0000
comments: true
---
This is work in progress...

1. Introduction
    - What is Apigility
    - Why APIs are so popular
        * decoupling software concepts
    - How does it tie up with modern development 
        * Microservices
        * Docker
        * DDD

2. The use case
    - Expose database tables via REST services
    - Expose business logic via RPC services

3. Sample skeleton application https://github.com/stefaniuk/learning-exercises/tree/master/apigility
    - Starting it up
    - Example calls

4. Problems
    - Include modules as Composer dependencies
    - Include modules in modules.config.php
    - Disable error reporting in php.ini "display_errors = Off"
    - Versions of the libraries
    - Entity and possible conflict with reserved words
    - Command-line tools
    - 'zf-apigility-doctrine' configuration options
    - 'zf-doctrine-querybuilder' configuration options

4. More advanced usage
    - Join tables http://stackoverflow.com/questions/35459020/apigility-doctrine-1-to-many-relationship-between-2-entities
    - Limit number of data items returned
