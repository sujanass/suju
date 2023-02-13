`uvm_analysis_imp_decl (_con1)
class sync_fifo_scoreboard extends uvm_scoreboard;

  `uvm_component_utils(sync_fifo_scoreboard)
  uvm_analysis_imp#(sync_fifo_seq_item, sync_fifo_scoreboard) scb_port;

  	sync_fifo_seq_item que[$];
	sync_fifo_seq_item trans;

	bit [9:0] mem[$];
	bit [9:0] tx_data;
	bit read_delay_clk;

  // new - constructor
  function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    scb_port = new("scb_port", this);
  endfunction: build_phase
  
 /* // write
  virtual function void write(sync_fifo_seq_item pkt);
    $display("SCB:: Pkt recived");
    pkt.print();
  endfunction : write*/

  // write function implementation
  function void write(sync_fifo_seq_item seq_item);
  que.push_back(seq_item);
  endfunction

  virtual task run_phase(uvm_phase phase);
    forever begin
    
    wait(que.size()>0);
    trans=que.pop_front();

    //WRITE
    if(trans.top_wr_en==1) begin
    mem.push_back(trans.top_wr_data);
    end
          
    //READ
    if(trans.top_rd_en==1 || (read_delay_clk != 35)) 
      	begin //if block starts here
          $display($time, "\t display 1 trans.top_rd_en = %d, read_delay_clk=%d", trans.top_rd_en, read_delay_clk);
          
      	if(read_delay_clk==35) read_delay_clk = 1;
         	 
          			else begin //else
            		if(trans.top_rd_en==0) read_delay_clk = 35;
                      $display($time, "\t display 2 trans.top_rd_en = %d, read_delay_clk=%d", trans.top_rd_en, read_delay_clk);

            		if(mem.size>0) 
                		begin
                  		tx_data = mem.pop_front();
                  		if(trans.top_rd_data==tx_data) 
                    	begin
                          `uvm_info("SCOREBOARD",$sformatf("------ :: EXPECTED MATCH  :: ------"),UVM_MEDIUM)
                     	`uvm_info("SCOREBOARD",$sformatf("Exp_Data: %0h, Act_data=%0h",tx_data,trans.top_rd_data),UVM_MEDIUM)
                     	`uvm_info("SCOREBOARD",$sformatf("-------------------------------------------------------"),UVM_MEDIUM)
                    	end
                  		else 
                    	begin
                          `uvm_info("SCOREBOARD",$sformatf("------ ::  FAILED MATCH  :: ------"),UVM_MEDIUM)
                      	`uvm_info("SCOREBOARD",$sformatf("Exp_Data: %0h, Act_data=%0h",tx_data,trans.top_rd_data),UVM_MEDIUM)
                      	`uvm_info("SCOREBOARD",$sformatf("-------------------------------------------------------"),UVM_MEDIUM)
                    	end
                		end
            		end //else
        end //if block ends here
          
      else
      read_delay_clk = 35;
    end

  endtask


 endclass : sync_fifo_scoreboard
