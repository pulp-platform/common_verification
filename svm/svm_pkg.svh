//SVM Base class lib:
//svm_component
//svm_trans
//svm_logger
//macros if any
//svm_generator
//svm_env
//svm_driver
//svm_monitor
//svm_scoreboard
//svm_test
//some useful typedefs
//
//
package svm_pkg;
  virtual class svm_component;
    string       name;
    svm_logger   log;

    virtual task reset ();
    virtual task build ();
    virtual task connect ();
    virtual task configure ();
    virtual task run();
    virtual task finish();
  endclass
  virtual class svm_trans;
    string       name;
    svm_logger   log;

    virtual function svm_trans cp();
    virtual task pr();
    virtual function bit compare(svm_trans trans);
  endclass
  virtual class svm_generator extends svm_component;
    svm_trans trans;
    mailbox   svm_trans gen2drvr_mbx;

    virtual functiona svm_trans gen ();

  endclass
  virtual class svm_driver extends svm_component;
    //TODO: connect gen2drvr _mbx to generators' gen2drvr_mbx;
    //TODO: replace durif in virtual interface declaration with appropriate
    //interface name
    //TODO:fill in the drive task
    //TODO:define a constructor which should:
    //a) create the mailbox
    //b) provide a name for the driver
    svm_trans trans;
    mailbox   svm_trans gen2drvr_mbx;
    virtual   interface dutif  vif;
    
    virtual task run ();
      while (1) begin
        trans = svm_trans.get();
        drive (trans);
        @ (posedge  vif.cb);
      end
    endtask
  endclass
  virtual class svm_env extends svm_component;
  //TODO: Create and allocae mailboxes for each gen2drv, drv2scbd, mon2scbd
  //TODO: Connect the mailboxes
  //TODO: create the build task to construt each component
  //TODO: Create configure task to use config object to configure components
  //TODO: Create run task to invoke the run tasks of each component.  Each
  
  //TODO: How are you going to determine when to exit?
  //TODO: Create a reset task to call the reset task of each component
  //TODO: Call finish task to to call $finish when all components are done
  //TODO: What scheme to indicate each component is done? Semaphore, event, ?
  //a, your checker should indicae when its done when all tans gen have
  //received a response
  //b. Each component takes a key from a semaphore and puts it back when its
  //done

    /***************************************/
    /**This task is optional do we need it? */
    /***************************************/
    virtual task run_test (svm_test test_to_run);
    //TODO: This is optional  Do we need a test class ro should we use plus
    //args to control the simulation
  endclass

  //this monitors the response and sends it to the scoreboard
  class svm_monitor extends svm_component;
    svm_trans trans;
    mailbox   svm_trans mon2scbd;

    virtual task sample ();
    //TODO: Add a new() function to construct this object
    //TODO: Create a run() task which forks off sample()
    //TODO: Create sample() task in which waits on a valid signal and then
    //sample the rest of the signals and send them to mbailbox. It needs to run
    //in a while (1) loop
  endclass
  class svm_scoreboard  extends svm_component;
    svm_trans         req;
    svm_trans         rsp;
    mailbox svm_trans drvr2scbd;
    mailbox svm_trans mon2scbd;

    svm_predictor     predictor;
    virtual function  bit check_rsp();
    virtual task          rcv_from_drvr();
    virtual task          rcv_from_mon ();
  endclass

  class svm_predictor extends svm_component;
    svm_trans trans_in;
    exp_rspQ svm_trans [$];

    virtual task set trans (svm_trans trans_in);
      this.trans_in = trans_in;
      process_trans();
    endtask

    virtual task process_trans ();
      
    virtual function svm_trans get_next_exp_rsp ();
      get_next_exp_rsp = exp_rspQ.pop_front();
    endfunction
  endclass
endpackage	

