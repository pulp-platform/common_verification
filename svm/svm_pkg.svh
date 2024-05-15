//SVM Base class library
//svm_component
//svm_trans
//svm_logger
//macros if any
//svm_generator
//svm_env
//svm_driver
//svm_monitor
//svm_scoreboard
//some useful typedefs
//
//
package svm_pkg;
  virtual class svm_component;
    string  name;
    virtual task reset ();
    virtual task build ();
    virtual task connect ();
    virtual task configure ();
    virtual task run();
    virtual task finish();
  endclass
  virtual class svm_trans;
    string name;

    virtual function svm_trans cp();
    virtual task pr();
    virtual function bit compare(svm_trans trans);
  endclass
  virtual class svm_generator extends svm_component;
    svm_trans trans;
    mailbox svm_trans toDriver;

    virtual functiona svm_trans gen ();

  endclass
  virtual class svm_driver extends svm_component;
    svm_trans trans;
    mailbox   svm_trans fromGen;

    virtual task drive ();
  endclass

endpackage	

