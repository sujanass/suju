# Show available test cases and options
#

run:	info

info:
	@echo "//-------------------------list of alias name available in make file ---------------------//"
	@echo "    along with make pass any of the one parameter to run corresponding test or to open waveform"
	@echo "    all                             ---->   to run all the below test cases use make all command"
	@echo "    base_test                      ---->   to run the otp_test.sv"
	@echo "    reset_test                    ---->   to run the otp_rst_test.sv"
	@echo "    otp_secure                ---->   to run the otp_secure_wr_rd_test.sv"
	@echo "    regression                ---->   to run the regression & source the cmd and open the imc"
	@echo "    waveform                ---->   to open the simvision"
	@echo "    clean                ---->   to delete the previous xrun files and cov files"

	@echo "//---------------------------------------------------------------------------------------//"

# Default target that runs all tests
all: base_test reset_test otp_secure waveform

# Base test case
base_test:
	@echo "[makefile]  base test case is running"
	xrun -access +rwc -f compile.f +UVM_TESTNAME=otp_test -uvmhome CDNS-1.1d -seed
	@echo "[makefile]  base test case run is completed successfully"

# reset test case
reset_test:
	@echo "[makefile]  reset test case is running"
	xrun -access +rwc -f compile.f +UVM_TESTNAME=otp_rst_test -uvmhome CDNS-1.1d -seed
	@echo "[makefile]  reset test case run is completed successfully"

# otp secure test case
otp_secure:
	@echo "[makefile]  otp secure test case running"
	xrun -access +rwc -f compile.f +UVM_TESTNAME=otp_secure_wr_rd_test -uvmhome CDNS-1.1d -seed
	@echo "[makefile]  otp secure test case run was successful"


#regression
regression:
	@echo "[makefile]  regression running"
	perl otp_regression.pl test_list.f 1
	source cmd
	imc -exec ./cov_files/cov_merge.cmd
	imc&	
	@echo "[makefile]  regression was successfully completed"

clean :

	rm -rf xrun.log / xrun.history / xcelium.d/ wave.shm/ cov_report.txt / cov_report_html/
	@echo "[makefile]  clean was successfully completed"

# Waveform viewing
waveform:
	simvision wave.shm &

