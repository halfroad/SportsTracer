# SportsTracer
Project for Testifying the Integration with iOS HealthKit

# Purpose of this project
This project aims to the 3rd phase of the Interview initiated by a very prestige company. I was asked to do the Coding Challenge, a demonstration project that read HKHealthKit from iPhone. 

In addition, a RestFul API should be called for the purpose of synchronising with backend, https://somedomain.com/_ah/api/myApi/v1/goals.

# prerequisites
If the user first launch the app, an authorisation window will be displayed to ask the user to allow the app to read/write health records in your device.

Please allow, and had better tick all the permissions. Otherwise, you will not be able to see the health data.

# Modules

## Glimpse of Today
This is the Summary of Today. The Steps you completed, and Walking and Running Distance you completed, and even your heart beats (Health records from Apple Watch, and other wearable devices.)

## Goals
This module is the Goals which acquired by the aforementioned API. The Steps, Walking and Running Distance will go with Health Records to determine whether the specific goal is accomplished or still in progress.

# Architecture
There are DEV, QA, UAT, PROD targets. By doing this, we can separate the target dependent settings, e.g. Host, API versions, etc.
There are 6 layers in the project, from underlying to UI, they are,

## Network

NetworkService, an encapsulation for URLSession and URLRequest
SecuredNetworkService, and inheritance of NetworkService to allow the caller to pass the header fields (Credentials for instance).
SSLPining, allow the app to verify the SSL/TLS certificate.
Goals/GoalService, the concrete service to call the API, and parse the HTTP response and body.

## Persistence
CoreData based pertinent persistence solution. Including Entity to model, Model to Entity interoperation. 

## Model
The model for Goal, Type, Reward. The model will be associated with API by JSONDecoder.

## Managers
Middle layer between UI/Controller and Network and CoreData and HKHealthKit. The creation for Core Data Entity is here, and HKHealthKit data preparation is also here.

# Miscellaneous

## Compatible backwards
The project is established over iOS 13. It is easy to downgrade the project to iOS12 to support legacy devices. As reported that, more that 85% devices has been upgraded to iOS13.

In addition, this is only a demonstration project, the purpose is to verify the skills of architecture of iOS project. 

## Real device debugging and running.

I understand that running and debugging the applications against a real device is crucial for iOS development, I really have a device. However, I only own the Enterprise Apple Development Program, and I am not able to create new App ID (Bundle ID) against this account.

As mentioned above, there are multiple targets in the project, my account does not have the permissions to create Capability of HKHealthKit. So I only debugged the app with Simulator. There could be some issues in real device. But most cases, it works for us.

Really appreciate the great opportunity, looking forward to contributing the COMPANY!

Thank you,
LI, Jin Hui

