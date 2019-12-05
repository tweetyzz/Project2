//	==================================================
//	Copyright (c) 2019 Sookmyung Women's University.
//	--------------------------------------------------
//	FILE 			: project.v
//	DEPARTMENT		: EE
//	AUTHOR			: JEIN YOO
//	EMAIL			: dbwpdls22@naver.com
//	--------------------------------------------------
//	RELEASE HISTORY
//	--------------------------------------------------
//	VERSION			DATE
//	0.0			2019-11-14
//	--------------------------------------------------
//	PURPOSE			: Digital Clock
//	==================================================

//	--------------------------------------------------
//	Numerical Controlled Oscillator
//	Hz of o_gen_clk = Clock Hz / num
//	--------------------------------------------------
module	nco(	
		o_gen_clk,
		i_nco_num,
		clk,
		rst_n);

output		o_gen_clk	;	// 1Hz CLK

input	[31:0]	i_nco_num	;
input		clk		;	// 50Mhz CLK
input		rst_n		;

reg	[31:0]	cnt		;
reg		o_gen_clk	;

always @(posedge clk or negedge rst_n) begin
	if(rst_n == 1'b0) begin
		cnt		<= 32'd0;
		o_gen_clk	<= 1'd0	;
	end else begin
		if(cnt >= i_nco_num/2-1) begin
			cnt 	<= 32'd0;
			o_gen_clk	<= ~o_gen_clk;
		end else begin
			cnt <= cnt + 1'b1;
		end
	end
end

endmodule

//	--------------------------------------------------
//	Flexible Numerical Display Decoder
//	--------------------------------------------------
module	fnd_dec(
		o_seg,
		i_num);

output	[6:0]	o_seg		;	// {o_seg_a, o_seg_b, ... , o_seg_g}

input	[3:0]	i_num		;
reg	[6:0]	o_seg		;
//making
always @(i_num) begin 
 	case(i_num) 
 		4'd0 : o_seg = 7'b111_1110	; 
 		4'd1 : o_seg = 7'b011_0000	; 
 		4'd2 : o_seg = 7'b110_1101	; 
 		4'd3 : o_seg = 7'b111_1001	; 
 		4'd4 : o_seg = 7'b011_0011	; 
 		4'd5 : o_seg = 7'b101_1011	; 
 		4'd6 : o_seg = 7'b101_1111	; 
 		4'd7 : o_seg = 7'b111_0000	; 
 		4'd8 : o_seg = 7'b111_1111	; 
 		4'd9 : o_seg = 7'b111_0011	; 
		default : o_seg = 7'b000_0000	; 
	endcase 
end


endmodule

//	--------------------------------------------------
//	reset
//	--------------------------------------------------
/*module 	reset(
		o_timer_sec,
		o_timer_min,
		o_timer_hour,
		i_timer_sec,
		i_timer_min,
		i_timer_hour,
		i_sw1,
		i_sw3,
		i_mode,
		clk,
		rst_n);

output	[5:0]	o_timer_sec		;
output	[5:0]	o_timer_min		;
output	[5:0]	o_timer_hour		;

input	[5:0]	i_timer_sec		;
input	[5:0]	i_timer_min		;
input	[5:0]	i_timer_hour		;

input	[2:0]	i_mode			;
input		i_sw1			;
input		i_sw3			;
input		clk			;
input		rst_n			;

reg	[5:0]	o_timer_sec		;
reg	[5:0]	o_timer_min		;
reg	[5:0]	o_timer_hour		;
always @ (posedge clk or negedge rst_n) begin
	if (rst_n == 1'b0) begin
		o_timer_sec <= 6'b0		;
		o_timer_min <= 6'b0		;
		o_timer_hour <= 6'b0		;
	end else begin
		if( i_sw3 == 1'b0 && i_mode == 3'b011 && i_sw1 == 1'b0 ) begin
			o_timer_sec <= 6'b0		;
			o_timer_min <= 6'b0		;
			o_timer_hour <= 6'b0		;
		end else begin 
			o_timer_sec <= i_timer_sec		;
			o_timer_min <= i_timer_min		;
			o_timer_hour <= i_timer_hour		;
		end
	end
end
endmodule*/
//	--------------------------------------------------
//	divide month
//	--------------------------------------------------
module	divide_month(
		o_date_day,
		o_max_hit_date_day,
		i_date_day_28,
		i_date_day_30,
		i_date_day_31,
		i_date_month,
		i_max_hit_date_day_28,
		i_max_hit_date_day_30,
		i_max_hit_date_day_31,
		clk,
		rst_n);


output	[5:0]	o_date_day		;
output		o_max_hit_date_day	;

input	[5:0]	i_date_day_28		;
input	[5:0]	i_date_day_30		;
input	[5:0]	i_date_day_31		;
input	[5:0]	i_date_month		;

input		i_max_hit_date_day_28		;
input		i_max_hit_date_day_30		;
input		i_max_hit_date_day_31		;

input		clk			;
input		rst_n			;

reg		o_max_hit_date_day	;
reg	[5:0]	o_date_day		;
always @ (posedge clk or negedge rst_n )begin
	if(rst_n == 1'b0) begin
		o_date_day <= 6'd0		;
	end else if((i_date_month == 6'd3)||(i_date_month == 6'd5)||(i_date_month == 6'd8)||(i_date_month == 6'd10)) begin
		o_date_day <= i_date_day_30	;
		o_max_hit_date_day <= i_max_hit_date_day_30	;
	end else if ((i_date_month == 6'd0)||(i_date_month == 6'd2)||(i_date_month == 6'd4)||(i_date_month == 6'd6)||(i_date_month == 6'd7)||(i_date_month == 6'd9)||(i_date_month == 6'd11)) begin
		o_date_day <= i_date_day_31	;
		o_max_hit_date_day <= i_max_hit_date_day_31	;
	end else if ((i_date_month == 6'd1)) begin
		o_date_day <= i_date_day_28	;
		o_max_hit_date_day <= i_max_hit_date_day_28	;
	end else begin
		o_date_day <= 6'd0		;
		o_max_hit_date_day <= 1'b0	;
	end
end
endmodule
//	--------------------------------------------------
//	0~59 --> 2 Separated Segments
//	--------------------------------------------------
module	double_fig_sep(
		o_left,
		o_right,
		i_double_fig);

output	[3:0]	o_left		;
output	[3:0]	o_right		;

input	[5:0]	i_double_fig	;

assign		o_left	= i_double_fig / 10	;
assign		o_right	= i_double_fig % 10	;

endmodule

//	--------------------------------------------------
//	0~59 --> 2 Separated Segments
//	--------------------------------------------------
module	led_disp(
		o_seg,
		o_seg_dp,
		o_seg_enb,
		i_six_digit_seg,
		i_six_dp,
		i_blink_position,
		clk,
		rst_n);

output	[5:0]	o_seg_enb		;
output		o_seg_dp		;
output	[6:0]	o_seg			;

input	[41:0]	i_six_digit_seg		;
input	[5:0]	i_six_dp		;
input	[1:0]	i_blink_position	;
input		clk			;
input		rst_n			;

wire		gen_clk		;

nco		u_nco(
		.o_gen_clk	( gen_clk	),
		.i_nco_num	( 32'd5000	),
		.clk		( clk		),
		.rst_n		( rst_n		));


reg	[3:0]	cnt_common_node	;

always @(posedge gen_clk or negedge rst_n) begin
	if(rst_n == 1'b0) begin
		cnt_common_node <= 4'd0;
	end else begin
		if(cnt_common_node >= 4'd5) begin
			cnt_common_node <= 4'd0;
		end else begin
			cnt_common_node <= cnt_common_node + 1'b1;
		end
	end
end

reg	[5:0]	o_seg_enb		;

always @(cnt_common_node) begin
	case (cnt_common_node)
		4'd0 : o_seg_enb = 6'b111110;
		4'd1 : o_seg_enb = 6'b111101;
		4'd2 : o_seg_enb = 6'b111011;
		4'd3 : o_seg_enb = 6'b110111;
		4'd4 : o_seg_enb = 6'b101111;
		4'd5 : o_seg_enb = 6'b011111;
	endcase
end

reg		o_seg_dp		;

always @(cnt_common_node) begin
	case (cnt_common_node)
		4'd0 : o_seg_dp = i_six_dp[0];
		4'd1 : o_seg_dp = i_six_dp[1];
		4'd2 : o_seg_dp = i_six_dp[2];
		4'd3 : o_seg_dp = i_six_dp[3];
		4'd4 : o_seg_dp = i_six_dp[4];
		4'd5 : o_seg_dp = i_six_dp[5];
	endcase
end

reg	[6:0]	o_seg			;

always @(cnt_common_node) begin
	case (cnt_common_node)
		4'd0 : o_seg = i_six_digit_seg[6:0];
		4'd1 : o_seg = i_six_digit_seg[13:7];
		4'd2 : o_seg = i_six_digit_seg[20:14];
		4'd3 : o_seg = i_six_digit_seg[27:21];
		4'd4 : o_seg = i_six_digit_seg[34:28];
		4'd5 : o_seg = i_six_digit_seg[41:35];
	endcase
end

endmodule
//	--------------------------------------------------
//	BLINK
//	--------------------------------------------------
module 	seg_blink(
		o_seg_sec_left,
		o_seg_sec_right,
		o_seg_min_left,
		o_seg_min_right,
		o_seg_hour_left,
		o_seg_hour_right,
		i_seg_sec_left,
		i_seg_sec_right,
		i_seg_min_left,
		i_seg_min_right,
		i_seg_hour_left,
		i_seg_hour_right,
		i_clock_sec,
		i_clock_min,
		i_clock_hour,
		i_alarm_sec,
		i_alarm_min,
		i_alarm_hour,
		i_position,
		i_mode,
		clk,
		rst_n);


input	[6:0]	i_seg_sec_left		;
input	[6:0]	i_seg_sec_right		;
input	[6:0]	i_seg_min_left		;
input	[6:0]	i_seg_min_right		;
input	[6:0]	i_seg_hour_left		;
input	[6:0]	i_seg_hour_right	;

input	[5:0]	i_clock_sec		;
input	[5:0]	i_clock_min		;
input	[5:0]	i_clock_hour		;
input	[5:0]	i_alarm_sec		;
input	[5:0]	i_alarm_min		;
input	[5:0]	i_alarm_hour		;

input	[1:0]	i_position		;
input	[2:0]	i_mode			;
input		clk			;
input		rst_n			;

output	[6:0]	o_seg_sec_left		;
output	[6:0]	o_seg_sec_right		;
output	[6:0]	o_seg_min_left		;
output	[6:0]	o_seg_min_right		;
output	[6:0]	o_seg_hour_left		;
output	[6:0]	o_seg_hour_right	;



reg	[6:0]	o_seg_sec_left		;
reg	[6:0]	o_seg_sec_right		;
reg	[6:0]	o_seg_min_left		;
reg	[6:0]	o_seg_min_right		;
reg	[6:0]	o_seg_hour_left		;
reg	[6:0]	o_seg_hour_right	;

wire		clk_1hz			;
nco		u1_nco(
		.o_gen_clk	( clk_1hz	),
		.i_nco_num	( 32'd50000000	),
		.clk		( clk		),
		.rst_n		( rst_n		));

always @ (posedge clk )	begin
	if(i_mode == 3'b001 || i_mode == 3'b010) begin
		if(i_position == 2'b00) begin
			if(clk_1hz == 1'b0) begin
			o_seg_sec_right <= 7'b0000000;
			o_seg_sec_left  <= 7'b0000000;
			o_seg_min_right <= i_seg_min_right;
			o_seg_min_left  <= i_seg_min_left ;
			o_seg_hour_right <= i_seg_hour_right;
			o_seg_hour_left  <= i_seg_hour_left ;
			end else begin
			o_seg_sec_right <= i_seg_sec_right;
			o_seg_sec_left  <= i_seg_sec_left ;
			o_seg_min_right <= i_seg_min_right;
			o_seg_min_left  <= i_seg_min_left ;
			o_seg_hour_right <= i_seg_hour_right;
			o_seg_hour_left  <= i_seg_hour_left ;
			end
		end else if(i_position == 2'b01) begin
			if(clk_1hz == 1'b0) begin
			o_seg_sec_right <= i_seg_sec_right;
			o_seg_sec_left  <= i_seg_sec_left ;
			o_seg_min_right <= 7'b0000000;
			o_seg_min_left  <= 7'b0000000;
			o_seg_hour_right <= i_seg_hour_right;
			o_seg_hour_left  <= i_seg_hour_left ;
			end else begin
			o_seg_sec_right <= i_seg_sec_right;
			o_seg_sec_left  <= i_seg_sec_left ;
			o_seg_min_right <= i_seg_min_right;
			o_seg_min_left  <= i_seg_min_left ;
			o_seg_hour_right <= i_seg_hour_right;
			o_seg_hour_left  <= i_seg_hour_left ;
			end
		end else if(i_position == 2'b10 ) begin
			if(clk_1hz == 1'b0) begin
			o_seg_sec_right <= i_seg_sec_right;
			o_seg_sec_left  <= i_seg_sec_left ;
			o_seg_min_right <= i_seg_min_right;
			o_seg_min_left  <= i_seg_min_left ;
			o_seg_hour_right <= 7'b0000000;
			o_seg_hour_left  <= 7'b0000000;
			end else begin
			o_seg_sec_right <= i_seg_sec_right;
			o_seg_sec_left  <= i_seg_sec_left ;
			o_seg_min_right <= i_seg_min_right;
			o_seg_min_left  <= i_seg_min_left ;
			o_seg_hour_right<= i_seg_hour_right;
			o_seg_hour_left  <= i_seg_hour_left ;
			end
		end else begin
			o_seg_sec_right <= i_seg_sec_right;
			o_seg_sec_left  <= i_seg_sec_left ;
			o_seg_min_right <= i_seg_min_right;
			o_seg_min_left  <= i_seg_min_left ;
			o_seg_hour_right <= i_seg_hour_right;
			o_seg_hour_left  <= i_seg_hour_left ;
		end
	end else if(i_mode == 3'b000) begin
		/*if(rst_n == 1'b0 ) begin
			o_seg_sec_right <= i_seg_sec_right;
			o_seg_sec_left  <= i_seg_sec_left ;
			o_seg_min_right <= i_seg_min_right;
			o_seg_min_left  <= i_seg_min_left ;
			o_seg_hour_right<= i_seg_hour_right;
			o_seg_hour_left  <= i_seg_hour_left ;*/
		//if((i_alarm_sec != 6'd0) && (i_alarm_min != 6'd0) && (i_alarm_hour!= 6'd0)) begin
			if((i_clock_sec + 6'd10  == i_alarm_sec) && (i_clock_min == i_alarm_min) && (i_clock_hour  == i_alarm_hour)) begin
			if(clk_1hz == 1'b0) begin
			o_seg_sec_right <= 7'b0000000;
			o_seg_sec_left  <= 7'b0000000;
			o_seg_min_right <= 7'b0000000;
			o_seg_min_left  <= 7'b0000000;
			o_seg_hour_right <= 7'b0000000;
			o_seg_hour_left  <= 7'b0000000;
			end else begin
			o_seg_sec_right <= i_seg_sec_right;
			o_seg_sec_left  <= i_seg_sec_left ;
			o_seg_min_right <= i_seg_min_right;
			o_seg_min_left  <= i_seg_min_left ;
			o_seg_hour_right<= i_seg_hour_right;
			o_seg_hour_left  <= i_seg_hour_left ;
			end
		end else if((i_clock_sec  == i_alarm_sec) && (i_clock_min == i_alarm_min) && (i_clock_hour  == i_alarm_hour)) begin	
			o_seg_sec_right <= i_seg_sec_right;
			o_seg_sec_left  <= i_seg_sec_left ;
			o_seg_min_right <= i_seg_min_right;
			o_seg_min_left  <= i_seg_min_left ;
			o_seg_hour_right<= i_seg_hour_right;
			o_seg_hour_left  <= i_seg_hour_left ;
		end
	end else begin
		o_seg_sec_right <= i_seg_sec_right;
		o_seg_sec_left  <= i_seg_sec_left ;
		o_seg_min_right <= i_seg_min_right;
		o_seg_min_left  <= i_seg_min_left ;
		o_seg_hour_right <= i_seg_hour_right;
		o_seg_hour_left  <= i_seg_hour_left ;
	end
end
endmodule
//	--------------------------------------------------
//	HMS(Hour:Min:Sec) Counter
//	--------------------------------------------------
module	hms_cnt(
		o_hms_cnt,
		o_max_hit,
		i_max_cnt,
		i_sw1,
		i_sw2,
		i_mode,
		clk,
		rst_n);

output	[5:0]	o_hms_cnt		;
output		o_max_hit		;

input	[5:0]	i_max_cnt		;

input		i_sw1			;
input		i_sw2			;
input	[2:0]	i_mode			;
input		clk			;
input		rst_n			;

reg	[5:0]	o_hms_cnt		;
reg		o_max_hit		;

always @(posedge clk or negedge rst_n) begin
	if(rst_n == 1'b0 ) begin
		o_hms_cnt <= 6'd0;
		o_max_hit <= 1'b0;
	end else begin
		if(o_hms_cnt >= i_max_cnt) begin
			o_hms_cnt <= 6'd0;
			o_max_hit <= 1'b1;
		end else if ( (i_sw1 == 1'b0) && (i_mode == 3'b011) && (i_sw2 == 1'b1)) begin
			o_hms_cnt <= 6'd0;
			o_max_hit <= 1'b0;
		end else begin
			o_hms_cnt <= o_hms_cnt + 1'b1;
			o_max_hit <= 1'b0;
		end
	end
end

/*always @(posedge clk or negedge rst_n) begin
	if(rst_n == 1'b0) begin
		o_hms_cnt <= 6'd0;
		//o_max_hit <= 1'b0;
	end else begin
		if( (i_sw2 == 1'b0) && (i_mode == 3'b011) && (i_sw1 == 1'b0) ) begin
			o_hms_cnt <= 6'd0;
			//o_max_hit <= 1'b0;
		end else begin 
			o_hms_cnt <= o_hms_cnt;
			//o_max_hit <= i_hms_cnt;
		end
	end
end*/

endmodule

//	--------------------------------------------------
//	HMS(Hour:Min:Sec) Counter reset
//	--------------------------------------------------
/*module	hms_cnt_reset(
		o_hms_cnt,
		//o_max_hit,
		i_hms_cnt,
		//i_max_cnt,
		i_sw1,
		i_sw2,
		i_mode,
		clk,
		rst_n);

output	[5:0]	o_hms_cnt		;
//output		o_max_hit		;

input	[5:0]	i_hms_cnt		;
//input	[5:0]	i_max_cnt		;
input		i_sw1			;
input		i_sw2			;
input	[2:0]	i_mode			;
input		clk			;
input		rst_n			;

reg	[5:0]	o_hms_cnt		;
//reg		o_max_hit		;
always @(posedge clk or negedge rst_n) begin
	if(rst_n == 1'b0) begin
		o_hms_cnt <= 6'd0;
		//o_max_hit <= 1'b0;
	end else begin
		if( (i_sw2 == 1'b0) && (i_mode == 3'b011) && (i_sw1 == 1'b0) ) begin
			o_hms_cnt <= 6'd0;
			//o_max_hit <= 1'b0;
		end else begin 
			o_hms_cnt <= i_hms_cnt;
			//o_max_hit <= i_hms_cnt;
		end
	end
end

endmodule*/

module  debounce(
		o_sw,
		i_sw,
		clk);
output		o_sw			;

input		i_sw			;
input		clk			;

reg		dly1_sw			;
always @(posedge clk) begin
	dly1_sw <= i_sw;
end

reg		dly2_sw			;
always @(posedge clk) begin
	dly2_sw <= dly1_sw;
end

assign		o_sw = dly1_sw | ~dly2_sw;

endmodule

//	--------------------------------------------------
//	Clock Controller
//	--------------------------------------------------
module	controller(
		o_mode,
		o_dp,
		o_position,
		o_alarm_en,
		o_timer,            //sw1
		o_timer_reset,      //sw2  
		o_sec_clk,
		o_min_clk,
		o_hour_clk,
		o_alarm_sec_clk,
		o_alarm_min_clk,
		o_alarm_hour_clk,
		o_timer_sec_clk,
		o_timer_min_clk,
		o_timer_hour_clk,
		o_date_day_clk,
		o_date_month_clk,
		o_date_year_clk,
		i_max_hit_clock_sec,
		i_max_hit_clock_min,
		i_max_hit_clock_hour,
		i_max_hit_alarm_sec,
		i_max_hit_alarm_min,
		i_max_hit_alarm_hour,
		i_max_hit_timer_sec,
	  	i_max_hit_timer_min,
  	        i_max_hit_timer_hour,
		i_max_hit_date_day,
		i_max_hit_date_month,
		i_max_hit_date_year,
		i_sw0,
		i_sw1,
		i_sw2,
		i_sw3,
		clk,
		rst_n);

output		o_mode			;
output		o_dp			;
output		o_position		;
output		o_alarm_en		;
output  	o_timer  	        ;
output  	o_timer_reset 		;   //  

output		o_sec_clk		;
output		o_min_clk		;
output		o_hour_clk		;

output		o_alarm_sec_clk		;
output		o_alarm_min_clk		;
output		o_alarm_hour_clk	;

output		o_timer_sec_clk		;
output		o_timer_min_clk		;
output		o_timer_hour_clk	;

output		o_date_day_clk		;
output		o_date_month_clk	;
output		o_date_year_clk		;

input		i_max_hit_clock_sec	;
input		i_max_hit_clock_min	;
input		i_max_hit_clock_hour	;

input		i_max_hit_alarm_sec	;
input		i_max_hit_alarm_min	;
input		i_max_hit_alarm_hour	;

input		i_max_hit_timer_sec	;
input		i_max_hit_timer_min	;
input		i_max_hit_timer_hour	;

input		i_max_hit_date_day	;
input		i_max_hit_date_month	;
input		i_max_hit_date_year	;

input		i_sw0			;
input		i_sw1			;
input		i_sw2			;
input		i_sw3			;

input		clk			;
input		rst_n			;


parameter	MODE_CLOCK = 3'b000	;
parameter	MODE_SETUP = 3'b001	;
parameter	MODE_ALARM = 3'b010	;
parameter 	MODE_TIMER = 3'b011 	; // MODE_TIMER(MODE3)
parameter	MODE_DATE  = 3'b100	;
parameter	MODE_DATE_SETUP = 3'b101;

parameter	POS_SEC	= 2'b00		;
parameter	POS_MIN	= 2'b01		;
parameter	POS_HOUR= 2'b10		;//?? ?? ?? 

parameter	TIMER_START = 1'b1  	;   //sw1 : START/STOP
parameter 	TIMER_STOP = 1'b0 	;	

parameter 	TIMER_STOP_1 = 1'b0 	;	
parameter 	TIMER_STOP_RESET = 1'b1	;

wire		clk_100hz		;
nco		u0_nco(
		.o_gen_clk	( clk_100hz	),
		.i_nco_num	( 32'd500000	),
		.clk		( clk		),
		.rst_n		( rst_n		));

wire		sw0			;
debounce	u0_debounce(
		.o_sw		( sw0		),
		.i_sw		( i_sw0		),
		.clk		( clk_100hz	));

wire		sw1			;
debounce	u1_debounce(
		.o_sw		( sw1		),
		.i_sw		( i_sw1		),
		.clk		( clk_100hz	));

wire		sw2			;
debounce	u2_debounce(
		.o_sw		( sw2		),
		.i_sw		( i_sw2		),
		.clk		( clk_100hz	));

wire		sw3			;
debounce	u3_debounce(
		.o_sw		( sw3		),
		.i_sw		( i_sw3		),
		.clk		( clk_100hz	));

reg	[2:0]	o_mode			;
reg	[5:0]	o_dp			;
always @(posedge sw0 or negedge rst_n) begin
	if(rst_n == 1'b0) begin
		o_mode <= MODE_CLOCK;
		o_dp   <= 6'b010101;	// time dot
	end else begin
		if(o_mode >= MODE_DATE_SETUP) begin
			o_mode <= MODE_CLOCK;
			o_dp   <= 6'b010101; 	// time dot
		end else begin
			o_mode <= o_mode + 1'b1;
			o_dp   <= o_mode + 1'b1;	//set up -> dot1, alarm -> dot2 
		end
	end
end


reg	[1:0]	o_position		;
always @(posedge sw1 or negedge rst_n) begin
	if(rst_n == 1'b0) begin
		o_position <= POS_SEC;
	end else begin
		if(o_position >= POS_HOUR) begin
		o_position <= POS_SEC;
		end else begin
		o_position <= o_position + 1'b1;
		//o_dp	   <= o_position + 1'b1; //o_position dp 
		end
	end
end
//timer. sw1. start/stop
reg 	 o_timer ;
always@(posedge sw1 or negedge rst_n) begin
	if(rst_n == 1'b0) begin
		o_timer <= TIMER_STOP;
	end else begin
		o_timer <= o_timer + 1'b1;
	end
end


reg	o_reset;
always@(posedge sw2 or negedge rst_n) begin
	if(rst_n == 1'b0) begin
		o_reset <= 1'b0;
	end else begin
		o_reset <= o_reset + 1'b1;
	end
end

reg		o_alarm_en		;
always @(posedge sw3 or negedge rst_n) begin
	if(rst_n == 1'b0) begin
		o_alarm_en <= 1'b0;
	end else begin
		o_alarm_en <= o_alarm_en + 1'b1;
	end
end 

wire		clk_1hz			;
nco		u1_nco(
		.o_gen_clk	( clk_1hz	),
		.i_nco_num	( 32'd50000000	),
		.clk		( clk		),
		.rst_n		( rst_n		));

reg		o_sec_clk		;
reg		o_min_clk		;
reg		o_hour_clk		;

reg		o_alarm_sec_clk		;
reg		o_alarm_min_clk		;
reg		o_alarm_hour_clk	;

reg		o_timer_sec_clk		;
reg		o_timer_min_clk		;
reg		o_timer_hour_clk	;

reg		o_date_day_clk		;
reg		o_date_month_clk	;
reg		o_date_year_clk		;




always @(*) begin
	case(o_mode)
		MODE_CLOCK : begin
			o_sec_clk = clk_1hz;
			o_min_clk = i_max_hit_clock_sec;
			o_hour_clk= i_max_hit_clock_min;
		end
		MODE_SETUP : begin
			case(o_position)
				POS_SEC	 : begin
					o_sec_clk = ~sw2;
					o_min_clk = 1'b0;
					o_hour_clk= 1'b0;

				end
				POS_MIN	 : begin
					o_sec_clk = 1'b0;
					o_min_clk = ~sw2;
					o_hour_clk= 1'b0;
				end
				POS_HOUR : begin
					o_sec_clk = 1'b0;
					o_min_clk = 1'b0;
					o_hour_clk= ~sw2;
				end
			endcase
		end

		MODE_ALARM : begin
			case(o_position)
				POS_SEC	 : begin
					o_sec_clk = clk_1hz;
					o_min_clk = i_max_hit_clock_sec;
					o_hour_clk= i_max_hit_clock_min;
					o_alarm_sec_clk  = ~sw2;
					o_alarm_min_clk  = 1'b0;
					o_alarm_hour_clk = 1'b0;
				end
				POS_MIN  : begin
					o_sec_clk = clk_1hz;
					o_min_clk = i_max_hit_clock_sec;
					o_hour_clk= i_max_hit_clock_min;
					o_alarm_sec_clk = 1'b0;
					o_alarm_min_clk = ~sw2;
					o_alarm_hour_clk = 1'b0;
				end
				POS_HOUR : begin
					o_sec_clk = clk_1hz;
					o_min_clk = i_max_hit_clock_sec;
					o_hour_clk= i_max_hit_clock_min;
					o_alarm_sec_clk = 1'b0;
					o_alarm_min_clk = 1'b0;
					o_alarm_hour_clk = ~sw2;
				end
			endcase
		end
	     	 MODE_TIMER : begin        //MODE_TIMER
	               case(o_timer)
	                  TIMER_START : begin
			   o_sec_clk = clk_1hz;
			   o_min_clk = i_max_hit_clock_sec;
			   o_hour_clk= i_max_hit_clock_min;
	        	   o_timer_sec_clk = clk_1hz;
	      		   o_timer_min_clk = i_max_hit_timer_sec;
	       		   o_timer_hour_clk= i_max_hit_timer_min;
			 end
			  TIMER_STOP : begin  
				case(o_reset)
				 TIMER_STOP_1 : begin        //
				   o_sec_clk = clk_1hz;
				   o_min_clk = i_max_hit_clock_sec;
				   o_hour_clk= i_max_hit_clock_min;
				   o_timer_sec_clk = 1'b0;
				   o_timer_min_clk = 1'b0;
				   o_timer_hour_clk= 1'b0;
				end
				TIMER_STOP_RESET : begin       //
				   o_sec_clk = clk_1hz;
				   o_min_clk = i_max_hit_clock_sec;
				   o_hour_clk= i_max_hit_clock_min;
				    o_timer_sec_clk = 1'b0;
	      			   o_timer_min_clk = 1'b0;
	       			   o_timer_hour_clk= 1'b0;
				 end
				endcase
			 end
		    /*  case(o_timer_reset)
		  	 TIMER_RESET : begin     
		     	   o_sec_clk = clk_1hz;
			   o_min_clk = i_max_hit_clock_sec;
			   o_hour_clk= i_max_hit_clock_min;
	        	   o_timer_sec_clk = clk_1hz;
	      		   o_timer_min_clk = i_max_hit_timer_sec;
	       		   o_timer_hour_clk= i_max_hit_timer_min;
			  end
			endcase*/
			endcase
		end	
		MODE_DATE : begin
				o_sec_clk = clk_1hz;
				o_min_clk = i_max_hit_clock_sec;
				o_hour_clk= i_max_hit_clock_min;
				o_date_day_clk = i_max_hit_clock_hour;
				o_date_month_clk  = i_max_hit_date_day;
				o_date_year_clk = i_max_hit_date_month;
		end
		MODE_DATE_SETUP : begin
			case(o_position)
				POS_SEC  : begin
					o_sec_clk = clk_1hz;
					o_min_clk = i_max_hit_clock_sec;
					o_hour_clk= i_max_hit_clock_min;
					o_date_day_clk = ~sw2;
					o_date_month_clk = 1'b0;
					o_date_year_clk = 1'b0;
				end
				POS_MIN  : begin
					o_sec_clk = clk_1hz;
					o_min_clk = i_max_hit_clock_sec;
					o_hour_clk= i_max_hit_clock_min;
					o_date_day_clk = 1'b0;
					o_date_month_clk =~sw2;
					o_date_year_clk = 1'b0;
				end
				POS_HOUR : begin
					o_sec_clk = clk_1hz;
					o_min_clk = i_max_hit_clock_sec;
					o_hour_clk= i_max_hit_clock_min;
					o_date_day_clk = 1'b0;
					o_date_month_clk = 1'b0;
					o_date_year_clk = ~sw2;
				end
			endcase
		end
		default: begin
			o_sec_clk = 1'b0;
			o_min_clk = 1'b0;
			o_hour_clk= 1'b0;
			o_alarm_sec_clk = 1'b0;
			o_alarm_min_clk = 1'b0;
			o_alarm_hour_clk= 1'b0;
			o_timer_sec_clk = 1'b0;
			o_timer_min_clk = 1'b0;
			o_timer_hour_clk= 1'b0;
			o_date_day_clk = 1'b0;
			o_date_month_clk = 1'b0;
			o_date_year_clk = 1'b0;
			end
		endcase
		end
endmodule

//	--------------------------------------------------
//	HMS(Hour:Min:Sec) Counter
//	--------------------------------------------------
module	minsec(	
		o_sec,
		o_min,
		o_hour,
		o_clock_sec,
		o_clock_min,
		o_clock_hour,
		o_alarm_sec,
		o_alarm_min,
		o_alarm_hour,
		o_date_day,
		o_date_month,
		o_date_year,
		o_max_hit_clock_sec,
		o_max_hit_clock_min,
		o_max_hit_clock_hour,	
		o_max_hit_alarm_sec,
		o_max_hit_alarm_min,
		o_max_hit_alarm_hour,
		o_max_hit_timer_sec,
		o_max_hit_timer_min,
		o_max_hit_timer_hour,	
		o_max_hit_date_day,
		o_max_hit_date_month,
		o_max_hit_date_year,
		o_alarm,
		o_alarm_ontime,
		i_mode,
		i_position,
		i_timer,
                i_timer_reset,
		i_sec_clk,
		i_min_clk,
		i_hour_clk,
		i_alarm_sec_clk,
		i_alarm_min_clk,
		i_alarm_hour_clk,
		i_alarm_en,
		i_timer_sec_clk,
		i_timer_min_clk,
		i_timer_hour_clk,
		i_date_day_clk,
		i_date_month_clk,
		i_date_year_clk,
		i_sw1,
		i_sw2,
		clk,
		rst_n);

output	[5:0]	o_sec			;
output	[5:0]	o_min			;
output	[5:0]	o_hour			;//[5:0]?? 
output		o_max_hit_clock_sec	;
output		o_max_hit_clock_min	;
output		o_max_hit_clock_hour	;

output		o_max_hit_alarm_sec	;
output		o_max_hit_alarm_min	;
output		o_max_hit_alarm_hour	;
output		o_alarm			;
output  o_alarm_ontime ;

output		o_max_hit_timer_sec	;
output		o_max_hit_timer_min	;
output		o_max_hit_timer_hour	;//

output		o_max_hit_date_day	;
output		o_max_hit_date_month	;
output		o_max_hit_date_year	;

output	[5:0]	o_clock_sec		;
output	[5:0]	o_clock_min		;
output	[5:0]	o_clock_hour		;

output	[5:0]	o_alarm_sec		;
output	[5:0]	o_alarm_min		;
output	[5:0]	o_alarm_hour		;

output	[5:0]	o_date_day		;
output	[5:0]	o_date_month		;
output	[5:0]	o_date_year		;

input	[2:0]	i_mode		;
input		i_position	;
input		i_timer		;
input  i_timer_reset	;

input		i_sec_clk	;
input		i_min_clk	;
input		i_hour_clk	;

input		i_alarm_sec_clk	;
input		i_alarm_min_clk	;
input		i_alarm_hour_clk;
input		i_alarm_en	;

input		i_timer_sec_clk	;
input		i_timer_min_clk	;
input		i_timer_hour_clk;

input		i_date_day_clk	;
input		i_date_month_clk	;
input		i_date_year_clk;

input		i_sw1		;
input		i_sw2		;
input		clk		;
input		rst_n		;

parameter	MODE_CLOCK = 3'b000	;
parameter	MODE_SETUP = 3'b001	;
parameter	MODE_ALARM = 3'b010	;
parameter 	MODE_TIMER = 3'b011 	; // MODE_TIMER(MODE3)
parameter	MODE_DATE  = 3'b100	;
parameter	MODE_DATE_SETUP  = 3'b101	;

parameter	POS_SEC		= 2'b00	;
parameter	POS_MIN		= 2'b01	;
parameter	POS_HOUR	= 2'b10	;

parameter 	TIMER_START 	= 1'b1  ;   //sw1 : START/STOP
parameter 	TIMER_STOP 	= 1'b0  ;

parameter 	TIMER_STOP1 		= 1'b0  ;
parameter	TIMER_STOP_RESET	= 1'b1	;

wire	[5:0]	clock_sec	;

hms_cnt		u0_hms_cnt(
		.o_hms_cnt	( clock_sec		),
		.o_max_hit	( o_max_hit_clock_sec	),
		.i_max_cnt	( 6'd59			),
		.i_sw1	( i_sw1),
		.i_sw2	( i_sw2),
		.i_mode	( i_mode),
		.clk		( i_sec_clk		),
		.rst_n		( rst_n			));

wire	[5:0]	clock_min	;
hms_cnt		u1_hms_cnt(
		.o_hms_cnt	( clock_min	),
		.o_max_hit	( o_max_hit_clock_min	),
		.i_max_cnt	( 6'd59			),
		.i_sw1	( i_sw1),
		.i_sw2	( i_sw2),
		.i_mode	( i_mode),
		.clk		( i_min_clk		),
		.rst_n		( rst_n			));


wire	[5:0]	clock_hour	;
hms_cnt		u2_hms_cnt(
		.o_hms_cnt	( clock_hour		),
		.o_max_hit	( o_max_hit_clock_hour	),
		.i_max_cnt	( 6'd23			),
		.i_sw1	( i_sw1),
		.i_sw2	( i_sw2),
		.i_mode	( i_mode),
		.clk		( i_hour_clk		),
		.rst_n		( rst_n			));

//	MODE_ALARM
wire	[5:0]	alarm_sec	;
hms_cnt		u_hms_cnt_alarm_sec(
		.o_hms_cnt	( alarm_sec		),
		.o_max_hit	( o_max_hit_alarm_sec	),
		.i_max_cnt	( 6'd59			),
		.i_sw1	( i_sw1),
		.i_sw2	( i_sw2),
		.i_mode	( i_mode),
		.clk		( i_alarm_sec_clk	),
		.rst_n		( rst_n			));

wire	[5:0]	alarm_min	;
hms_cnt		u_hms_cnt_alarm_min(
		.o_hms_cnt	( alarm_min		),
		.o_max_hit	( o_max_hit_alarm_min	),
		.i_max_cnt	( 6'd59			),
		.i_sw1	( i_sw1),
		.i_sw2	( i_sw2),
		.i_mode	( i_mode),
		.clk		( i_alarm_min_clk	),
		.rst_n		( rst_n			));

wire	[5:0]	alarm_hour	;
hms_cnt		u_hms_cnt_alarm_hour(
		.o_hms_cnt	( alarm_hour		),
		.o_max_hit	( o_max_hit_alarm_hour	),
		.i_max_cnt	( 6'd23			),
		.i_sw1	( i_sw1),
		.i_sw2	( i_sw2),
		.i_mode	( i_mode),
		.clk		( i_alarm_hour_clk	),
		.rst_n		( rst_n			));
//MODE TIMER
wire	[5:0]	timer_sec	;
hms_cnt		u_hms_cnt_timer_sec(
		.o_hms_cnt	( timer_sec		),
		.o_max_hit	( o_max_hit_timer_sec	),
		.i_max_cnt	( 6'd59			),
		.i_sw1	( i_sw1),
		.i_sw2	( i_sw2),
		.i_mode	( i_mode),
		.clk		( i_timer_sec_clk		),
		.rst_n		( rst_n			));




/*wire	[5:0]	timer_sec	;
hms_cnt_reset	u_hms_cnt_reset0(
				.o_hms_cnt( timer_sec),
				//o_max_hit,
				.i_hms_cnt(i_timer_sec),
				//i_max_cnt,
				.i_sw1	( i_sw1),
				.i_sw2	( i_sw2),
				.i_mode	( i_mode),
				.clk	(clk),
				.rst_n	(rst_n));*/

wire	[5:0]	timer_min	;
hms_cnt		u_hms_cnt_timer_min(
		.o_hms_cnt	( timer_min	),
		.o_max_hit	( o_max_hit_timer_min	),
		.i_max_cnt	( 6'd59			),
		.i_sw1	( i_sw1),
		.i_sw2	( i_sw2),
		.i_mode	( i_mode),
		.clk		( i_timer_min_clk	),
		.rst_n		( rst_n			));

/*wire	[5:0]	timer_min	;
hms_cnt_reset	u_hms_cnt_reset1(
				.o_hms_cnt( timer_min),
				//o_max_hit,
				.i_hms_cnt(i_timer_min),
				//i_max_cnt,
				.i_sw1	( i_sw1),
				.i_sw2	( i_sw2),
				.i_mode	( i_mode),
				.clk	(clk),
				.rst_n	(rst_n));*/


wire	[5:0]	timer_hour	;
hms_cnt		u_hms_cnt_timer_hour(
		.o_hms_cnt	( timer_hour		),
		.o_max_hit	( o_max_hit_timer_hour	),
		.i_max_cnt	( 6'd23			),
		.i_sw1	( i_sw1),
		.i_sw2	( i_sw2),
		.i_mode	( i_mode),
		.clk		( i_timer_hour_clk	),
		.rst_n		( rst_n			));

/*wire	[5:0]	timer_hour	;
hms_cnt_reset	u_hms_cnt_reset2(
				.o_hms_cnt( timer_hour),
				//o_max_hit,
				.i_hms_cnt(i_timer_hour ),
				//i_max_cnt,
				.i_sw1	( i_sw1),
				.i_sw2	( i_sw2),
				.i_mode	( i_mode),
				.clk	(clk),
				.rst_n	(rst_n));*/

wire	[5:0]	date_day_28	;
wire		max_hit_date_day_28	;
hms_cnt		u_hms_cnt_date_day_28(
		.o_hms_cnt	( date_day_28		),
		.o_max_hit	( max_hit_date_day_28	),
		.i_max_cnt	( 6'd27			),
		.i_sw1	( i_sw1),
		.i_sw2	( i_sw2),
		.i_mode	( i_mode),
		.clk		( i_date_day_clk	),
		.rst_n		( rst_n			));

wire	[5:0]	date_day_30	;
wire		max_hit_date_day_30	;
hms_cnt		u_hms_cnt_date_day_30(
		.o_hms_cnt	( date_day_30		),
		.o_max_hit	( max_hit_date_day_30	),
		.i_max_cnt	( 6'd29			),
		.i_sw1	( i_sw1),
		.i_sw2	( i_sw2),
		.i_mode	( i_mode),
		.clk		( i_date_day_clk	),
		.rst_n		( rst_n			));

wire	[5:0]	date_day_31	;
wire		max_hit_date_day_31	;
hms_cnt		u_hms_cnt_date_day_31(
		.o_hms_cnt	( date_day_31		),
		.o_max_hit	( max_hit_date_day_31	),
		.i_max_cnt	( 6'd30			),
		.i_sw1	( i_sw1),
		.i_sw2	( i_sw2),
		.i_mode	( i_mode),
		.clk		( i_date_day_clk	),
		.rst_n		( rst_n			));

wire	[5:0]	date_month	;
hms_cnt		u_hms_cnt_date_month(
		.o_hms_cnt	( date_month	),
		.o_max_hit	( o_max_hit_date_month	),
		.i_max_cnt	( 6'd11			),//
		.i_sw1	( i_sw1),
		.i_sw2	( i_sw2),
		.i_mode	( i_mode),
		.clk		( i_date_month_clk	),
		.rst_n		( rst_n			));


wire	[5:0]	date_year	;
hms_cnt		u_hms_cnt_date_year(
		.o_hms_cnt	( date_year		),
		.o_max_hit	( o_max_hit_date_year	),
		.i_max_cnt	( 6'd99			),
		.i_sw1	( i_sw1),
		.i_sw2	( i_sw2),
		.i_mode	( i_mode),
		.clk		( i_date_year_clk	),
		.rst_n		( rst_n			));


 
wire	[5:0]	date_day	;
divide_month	u_divide_month(
				.o_date_day	(date_day),
				.o_max_hit_date_day	( o_max_hit_date_day),
				.i_date_day_28	(date_day_28),	
				.i_date_day_30	(date_day_30),
				.i_date_day_31	(date_day_31),
				.i_date_month	(date_month),
				.i_max_hit_date_day_28	( max_hit_date_day_28),
				.i_max_hit_date_day_30	( max_hit_date_day_30),
				.i_max_hit_date_day_31	( max_hit_date_day_31),
				.clk		(clk	),
				.rst_n		(rst_n));


/*wire	[5:0]	timer_sec	;
wire	[5:0]	timer_min	;
wire	[5:0]	timer_hour	;
reset		u_reset(
				.o_timer_sec(timer_sec),
				.o_timer_min(timer_min),
				.o_timer_hour(timer_hour),
				.i_timer_sec(i_timer_sec),
				.i_timer_min(i_timer_min),
				.i_timer_hour(i_timer_hour),
				.i_sw1(i_sw1),
				.i_sw3(i_sw3),
				.i_mode(i_mode),
				.clk(clk),
				.rst_n(rst_n));*/

reg	[5:0]	o_sec		;
reg	[5:0]	o_min		;
reg	[5:0]	o_hour		;
always @ (*) begin
	case(i_mode)
		MODE_CLOCK: 	begin
			o_sec	= clock_sec	;
			o_min	= clock_min	;
			o_hour	= clock_hour	;
		end
		MODE_SETUP:	begin
			o_sec	= clock_sec	;
			o_min	= clock_min	;
			o_hour	= clock_hour	;
		end
		MODE_ALARM:	begin
			o_sec	= alarm_sec	;
			o_min	= alarm_min	;
			o_hour	= alarm_hour	;
		end
		MODE_TIMER : begin
		  	o_sec	= timer_sec	;
			o_min	= timer_min	;
			o_hour	= timer_hour	;
		end
		MODE_DATE : begin
			o_sec	= date_day + 1'b1	;
			o_min	= date_month + 1'b1	;
			o_hour	= date_year		;
		end
		MODE_DATE_SETUP : begin
			o_sec	= date_day + 1'b1	;
			o_min	= date_month + 1'b1	;
			o_hour	= date_year		;
		end
	endcase
end

reg		o_alarm		;
always @ (posedge clk or negedge rst_n) begin
	if (rst_n == 1'b0) begin
		o_alarm <= 1'b0		;
	end else begin
		if( (clock_sec == alarm_sec) && (clock_min == alarm_min) && (clock_hour == alarm_hour)) begin
			o_alarm <= 1'b1 & i_alarm_en	;
		end else begin
			o_alarm <= o_alarm & i_alarm_en	;
		end
	end
end

reg		o_alarm_ontime	;
always @ (posedge clk or negedge rst_n) begin
	if (rst_n == 1'b0) begin
		o_alarm_ontime <= 1'b0		; //start button
	end else begin
		if( (clock_sec == 6'd00) && (clock_min == 6'd00) && (clock_hour == 6'd12)) begin
			o_alarm_ontime <=  1'b1 	; //start button
		end else begin
			o_alarm_ontime <=  1'b0;
		end
	end
end
endmodule



module	buzz(
		o_buzz,
		i_buzz_en,
		clk,
		rst_n);

output		o_buzz		;

input		i_buzz_en	;
input		clk		;
input		rst_n		;

//6
parameter	C = 47778	;
parameter	D = 42566	;
parameter	E = 37920	;
parameter	F = 35794	;
parameter	G = 31800	;//-80
parameter	A = 28410	;
parameter	B = 25310	;

// 7
parameter C0 = 23800 ;//-80
parameter D0 = 21283 ;
parameter E2 = 20080 ; //Eb
parameter E0 = 18960 ;
parameter F0 = 17897 ;
parameter F1 = 16892 ; //F#
parameter G0 = 15900 ;//-40
parameter A0 = 14205 ;
parameter B0 = 12655 ;

//8
parameter C1 = 11940 ;
parameter D1 = 10641 ;
parameter E1 = 9480  ;
parameter F2 = 8948  ;
parameter F3 = 8446  ;//#
parameter G1 = 7950  ;
parameter A1 = 7102  ;
parameter B1 = 6327  ;//

wire		clk_bit		;
nco	u_nco_bit(	
		.o_gen_clk	( clk_bit	),
		.i_nco_num	( 12500000	),
		.clk		( clk		),
		.rst_n		( rst_n		));

reg	[6:0]	cnt		;
always @ (posedge clk_bit or negedge rst_n) begin
	if(rst_n == 1'b0) begin
		cnt <= 7'd0;
	end else if(i_buzz_en == 1'b0) begin
	    cnt <= 7'd0 ;
	    end else begin
		if(cnt >= 7'd127) begin
			cnt <= 7'd0;
		end else begin
			cnt <= cnt + 1'd1;
		end
	end
end

reg	[127:0]	nco_num		;
always @ (*) begin
	case(cnt)
		7'd00: nco_num = G	; 
		7'd01: nco_num = G	; 
    7'd02: nco_num = B	;
		7'd03: nco_num = B	;
		7'd04: nco_num = D0	;
		7'd05: nco_num = D0	; 
		7'd06: nco_num = F1	;
		7'd07: nco_num = G0 ;
		7'd08: nco_num = G0 ;
		7'd09: nco_num = F1	;
		7'd10: nco_num = F1	;
		7'd11: nco_num = E0	; 
		7'd12: nco_num = E0	;
		7'd13: nco_num = D0	;
		7'd14: nco_num = D0	;
		
		7'd15: nco_num = A0	;
		7'd16: nco_num = A0	;
		7'd17: nco_num = G0	;
		7'd18: nco_num = G0	;
		7'd19: nco_num = G0	;
		7'd20: nco_num = G0	;
		7'd21: nco_num = F1	;
		7'd22: nco_num = G0	;
		7'd23: nco_num = G0	;
		7'd24: nco_num = F1	; //
		7'd25: nco_num = E0	;
		7'd26: nco_num = E0	;
		7'd27: nco_num = D0	;
		7'd28: nco_num = D0	;
		
		7'd29: nco_num = C0	;
		7'd30: nco_num = C0	; 
		7'd31: nco_num = E0	;
		7'd32: nco_num = E0	;
		7'd33: nco_num = G0	;
		7'd34: nco_num = G0	; 
		7'd35: nco_num = A0	;
		7'd36: nco_num = B0	;
		7'd37: nco_num = B0	;
		7'd38: nco_num = A0	; 
		7'd39: nco_num = G0	;
		7'd40: nco_num = G0	; 
		7'd41: nco_num = E0	;
		7'd42: nco_num = E0	;
		
		7'd43: nco_num = B0	;
		7'd44: nco_num = B0	;
		7'd45: nco_num = D1	;
		7'd46: nco_num = D1	;
		7'd47: nco_num = B0	;
		7'd48: nco_num = A0	;
		7'd49: nco_num = G0	; 
		7'd50: nco_num = A0	;
		7'd51: nco_num = A0	;
		7'd52: nco_num = G0	;
		7'd53: nco_num = E2	;
		7'd54: nco_num = E2	;
		7'd55: nco_num = D0	; 
		7'd56: nco_num = D0	; 
		
		7'd57: nco_num = G0	;
		7'd58: nco_num = G0	;
		7'd59: nco_num = A0	;
		7'd60: nco_num = A0	;
		7'd61: nco_num = F1	;
		7'd62: nco_num = F1	;
		7'd63: nco_num = G0	;
		7'd64: nco_num = G0	;
		7'd65: nco_num = E0	;//
		7'd66: nco_num = E0	;
		7'd67: nco_num = F1	;
		7'd68: nco_num = F1	;
		7'd69: nco_num = E2	;
		7'd70: nco_num = E2	;
		7'd71: nco_num = E2	;
		7'd72: nco_num = E2	;
		
		7'd73: nco_num = B0	;
		7'd74: nco_num = B0	;
		7'd75: nco_num = A0	;
		7'd76: nco_num = A0	;
		7'd77: nco_num = A0	;
		7'd78: nco_num = G0	;
		7'd79: nco_num = G0	;
		7'd80: nco_num = F1	;
		7'd81: nco_num = F1	;
		7'd82: nco_num = G0	;
		7'd83: nco_num = G0	;
		7'd84: nco_num = E2	;
		7'd85: nco_num = E2	;
		7'd86: nco_num = E2	;
		7'd87: nco_num = E2	;
		
		7'd88: nco_num = D0	;
		7'd89: nco_num = D0	;
		7'd90: nco_num = E0	;
		7'd91: nco_num = E0	;
		7'd92: nco_num = G0	;
		7'd93: nco_num = D1	;
		7'd94: nco_num = D1	;
		7'd95: nco_num = C1	;
		7'd96: nco_num = C1	;
		7'd97: nco_num = C1	;
		7'd98: nco_num = C1	;
		7'd99: nco_num = C1	;
		7'd100: nco_num = C1	;
		7'd101: nco_num = C1	;
		7'd102: nco_num = C1	;
		7'd103: nco_num = C1	;
		
		7'd104: nco_num = B0	;
		7'd105: nco_num = B0	;
		7'd106: nco_num = A0	;
		7'd107: nco_num = A0	;
		7'd108: nco_num = G0	;
		7'd109: nco_num = G0	;
		7'd110: nco_num = E0	;
		7'd111: nco_num = E0	;
		7'd112: nco_num = E2	;
		7'd113: nco_num = A0	;
		7'd114: nco_num = A0	;
		7'd115: nco_num = A0	;
		7'd116: nco_num = A0	;
		7'd117: nco_num = A0	;
		7'd118: nco_num = B0	;
		7'd119: nco_num = B0	;
		7'd120: nco_num = G0	;
		7'd121: nco_num = G0	;
		7'd122: nco_num = G0	;
		7'd123: nco_num = G0	;
		7'd124: nco_num = G0	;
		7'd125: nco_num = G0	;
		7'd126: nco_num = G0	;
		7'd127: nco_num = G0	;	
		
	endcase
end

wire		buzz		;
nco	u_nco_buzz(	
		.o_gen_clk	( buzz		),
		.i_nco_num	( nco_num	),
		.clk		( clk		),
		.rst_n		( rst_n		));

assign		o_buzz = buzz & i_buzz_en;

endmodule

module	buzz0(  //newwwwwwwwwwwwwwwwwwwwwwwwwwwwwwww
		o_buzz0,
		//i_buzz_en,
		i_buzz_en0,
		clk,
		rst_n);

output		o_buzz0	;


input		i_buzz_en0	;
input		clk		;
input		rst_n		;

//6
parameter	C = 47778	;
parameter	D = 42566	;
parameter	E = 37920	;
parameter	F = 35794	;
parameter	G = 31800	;//-80
parameter	A = 28410	;
parameter	B = 25310	;

// 7
parameter C0 = 23800 ;//-80
parameter D0 = 21283 ;
parameter E2 = 20080 ; //Eb
parameter E0 = 18960 ;
parameter F0 = 17897 ;
parameter F1 = 16892 ; //F#
parameter G0 = 15900 ;//-40
parameter A0 = 14205 ;
parameter B0 = 12655 ;

//8
parameter C1 = 11940 ;
parameter D1 = 10641 ;
parameter E1 = 9480  ;
parameter F2 = 8948  ;
parameter F3 = 8446  ;//#
parameter G1 = 7950  ;
parameter A1 = 7102  ;
parameter B1 = 6327  ;//

wire		clk_bit		;
nco	u_nco_bit(	
		.o_gen_clk	( clk_bit	),
		.i_nco_num	( 12500000	),
		.clk		( clk		),
		.rst_n		( rst_n		));

reg	[6:0]	cnt		;
always @ (posedge clk_bit or negedge rst_n) begin
	if(rst_n == 1'b0) begin
		cnt <= 7'd0;
	end else if(i_buzz_en0 == 1'b0) begin
	    cnt <= 7'd0 ;
	    end else begin
		if(cnt >= 7'd126) begin
			cnt <= 7'd0;
		end else begin
			cnt <= cnt + 1'd1;
		end
	end
end

reg	[127:0]	nco_num		;
always @ (*) begin
	case(cnt)
		7'd00: nco_num = D1	; 
		7'd01: nco_num = B0	; 
    7'd02: nco_num = G0	;
		/*7'd03: nco_num = B	;
		7'd04: nco_num = D0	;
		7'd05: nco_num = D0	; 
		7'd06: nco_num = F1	;
		7'd07: nco_num = G0 ;
		7'd08: nco_num = G0 ;
		7'd09: nco_num = F1	;
		7'd10: nco_num = F1	;
		7'd11: nco_num = E0	; 
		7'd12: nco_num = E0	;
		7'd13: nco_num = D0	;
		7'd14: nco_num = D0	;
		
		7'd15: nco_num = A0	;
		7'd16: nco_num = A0	;
		7'd17: nco_num = G0	;
		7'd18: nco_num = G0	;
		7'd19: nco_num = G0	;
		7'd20: nco_num = G0	;
		7'd21: nco_num = F1	;
		7'd22: nco_num = G0	;
		7'd23: nco_num = G0	;
		7'd24: nco_num = F1	; //
		7'd25: nco_num = E0	;
		7'd26: nco_num = E0	;
		7'd27: nco_num = D0	;
		7'd28: nco_num = D0	;
		
		7'd29: nco_num = C0	;
		7'd30: nco_num = C0	; 
		7'd31: nco_num = E0	;
		7'd32: nco_num = E0	;
		7'd33: nco_num = G0	;
		7'd34: nco_num = G0	; 
		7'd35: nco_num = A0	;
		7'd36: nco_num = B0	;
		7'd37: nco_num = B0	;
		7'd38: nco_num = A0	; 
		7'd39: nco_num = G0	;
		7'd40: nco_num = G0	; 
		7'd41: nco_num = E0	;
		7'd42: nco_num = E0	;
		
		7'd43: nco_num = B0	;
		7'd44: nco_num = B0	;
		7'd45: nco_num = D1	;
		7'd46: nco_num = D1	;
		7'd47: nco_num = B0	;
		7'd48: nco_num = A0	;
		7'd49: nco_num = G0	; 
		7'd50: nco_num = A0	;
		7'd51: nco_num = A0	;
		7'd52: nco_num = G0	;
		7'd53: nco_num = E2	;
		7'd54: nco_num = E2	;
		7'd55: nco_num = D0	; 
		7'd56: nco_num = D0	; 
		
		7'd57: nco_num = G0	;
		7'd58: nco_num = G0	;
		7'd59: nco_num = A0	;
		7'd60: nco_num = A0	;
		7'd61: nco_num = F1	;
		7'd62: nco_num = F1	;
		7'd63: nco_num = G0	;
		7'd64: nco_num = G0	;
		7'd65: nco_num = E0	;//
		7'd66: nco_num = E0	;
		7'd67: nco_num = F1	;
		7'd68: nco_num = F1	;
		7'd69: nco_num = E2	;
		7'd70: nco_num = E2	;
		7'd71: nco_num = E2	;
		7'd72: nco_num = E2	;
		
		7'd73: nco_num = B0	;
		7'd74: nco_num = B0	;
		7'd75: nco_num = A0	;
		7'd76: nco_num = A0	;
		7'd77: nco_num = A0	;
		7'd78: nco_num = G0	;
		7'd79: nco_num = G0	;
		7'd80: nco_num = F1	;
		7'd81: nco_num = F1	;////
		7'd82: nco_num = G0	;
		7'd83: nco_num = G0	;
		7'd84: nco_num = E2	;
		7'd85: nco_num = E2	;
		7'd86: nco_num = E2	;
		7'd87: nco_num = E2	;
		
		7'd88: nco_num = D0	;
		7'd89: nco_num = D0	;
		7'd90: nco_num = E0	;
		7'd91: nco_num = E0	;
		7'd92: nco_num = G0	;
		7'd93: nco_num = D1	;
		7'd94: nco_num = D1	;
		7'd95: nco_num = C1	;
		7'd96: nco_num = C1	;
		7'd97: nco_num = C1	;
		7'd98: nco_num = C1	;
		7'd99: nco_num = C1	;
		7'd100: nco_num = C1	;
		7'd101: nco_num = C1	;
		7'd102: nco_num = C1	;
		7'd103: nco_num = C1	;
		
		7'd104: nco_num = B0	;
		7'd105: nco_num = B0	;
		7'd106: nco_num = A0	;
		7'd107: nco_num = A0	;
		7'd108: nco_num = G0	;
		7'd109: nco_num = G0	;
		7'd110: nco_num = E0	;
		7'd111: nco_num = E0	;
		7'd112: nco_num = E2	;
		7'd113: nco_num = A0	;
		7'd114: nco_num = A0	;
		7'd115: nco_num = A0	;
		7'd116: nco_num = A0	;
		7'd117: nco_num = A0	;
		7'd118: nco_num = B0	;
		7'd119: nco_num = B0	;
		7'd120: nco_num = G0	;
		7'd121: nco_num = G0	;
		7'd122: nco_num = G0	;
		7'd123: nco_num = G0	;
		7'd124: nco_num = G0	;
		7'd125: nco_num = G0	;
		7'd126: nco_num = G0	;*/
		
		
	endcase
end

wire		buzz		;
nco	u_nco_buzz(	
		.o_gen_clk	( buzz		),
		.i_nco_num	( nco_num	),
		.clk		( clk		),
		.rst_n		( rst_n		));

assign		o_buzz0 = buzz & i_buzz_en0;

endmodule
// ------------------------------------------------
// BUZZ_MUX
// ------------------------------------------------
module buzz_mux(
    o_buzz_mux,
    i_buzz_en,
    i_buzz_en0,
    clk,
    rst_n
      );
      
input clk ;
input rst_n;
input i_buzz_en;
input i_buzz_en0 ;
output  o_buzz_mux   ;
/*
module	buzz0(  //newwwwwwwwwwwwwwwwwwwwwwwwwwwwwwww
		o_buzz0,
		//i_buzz_en,
		i_buzz_en0, // alarm hms == clock hms
		clk,
		rst_n);
		
module	buzz(
		o_buzz,
		i_buzz_en, // clock hms == 12:00:00 
		clk,
		rst_n);
*/
wire  buzz0   ;
wire  buzz   ;
wire  o_alarm ;
wire  o_alarm_ontime ;

buzz u_buzz(
      .o_buzz     ( buzz      ),
		//i_buzz_en,
		  .i_buzz_en  ( i_buzz_en     ),
		  .clk        ( clk      ),
		  .rst_n      ( rst_n      ));
		  
buzz0 u_buzz0(
      .o_buzz0    ( buzz0      ),
		//i_buzz_en,
		  .i_buzz_en0 ( i_buzz_en0     ),
		  .clk        ( clk      ),
		  .rst_n      ( rst_n      ));
		  
reg	[1:0]	sel		;
always @ (*) begin
	if ( buzz == 1'b0 && buzz0 == 1'b0 ) begin
		sel <= 2'b00	;
	end else if ( buzz0 == 1'b1 && buzz == 1'b0 ) begin
		sel <= 2'b01 	;
	end else if ( buzz0 == 1'b0 && buzz == 1'b1 ) begin
		sel <= 2'b10	;
	end else begin
		sel <= 2'b11	;
	end
end


reg o_buzz_mux  ;		  
always @ (*) begin
  	if ( sel == 2'b00 ) begin
    	  o_buzz_mux <= 1'b0	;
  	end else if( sel == 2'b01 ) begin
    	  o_buzz_mux <= buzz0	;
	end else if( sel == 2'b10 || sel == 2'b11 ) begin
    	  o_buzz_mux <= buzz	;
	end else begin
	  o_buzz_mux <= 1'b0	;
  	end
end
  
endmodule

module	top_hms_clock(
		o_seg_enb,
		o_seg_dp,
		o_seg,
		o_buzz_mux,
		i_sw0,
		i_sw1,
		i_sw2,
		i_sw3,
		clk,
		rst_n);

output	[5:0]	o_seg_enb	;
output		o_seg_dp	;
output	[6:0]	o_seg		;
output		o_buzz_mux		;

input		i_sw0		;
input		i_sw1		;
input		i_sw2		;
input		i_sw3		;
input		clk		;
input		rst_n		;

wire	[2:0]	mode		;
wire	[5:0]	dp		;
wire	[1:0]	position	;
wire     	timer  ;

wire		sec_clk		;
wire		min_clk		;
wire		hour_clk	;

wire		max_hit_clock_sec	;
wire		max_hit_clock_min	;
wire		max_hit_clock_hour	;

wire		max_hit_alarm_sec	;
wire		max_hit_alarm_min	;
wire		max_hit_alarm_hour	;

wire		max_hit_timer_sec	;
wire		max_hit_timer_min	;
wire		max_hit_timer_hour	;

wire		max_hit_date_day	;
wire		max_hit_date_month	;
wire		max_hit_date_year	;

wire		alarm_sec_clk	;
wire		alarm_min_clk	;
wire		alarm_hour_clk	;
//wire		alarm_en	;

wire		timer_sec_clk	;
wire		timer_min_clk	;
wire		timer_hour_clk	;

wire		date_day_clk	;
wire		date_month_clk	;
wire		date_year_clk	;
controller	u_controller(	.o_mode			( mode			),
				.o_dp			( dp			),
				.o_position		( position		),
				.o_alarm_en		( alarm_en		),
				.o_timer     (  timer   ),
				.o_timer_reset (          ),
				.o_sec_clk		( sec_clk		),
				.o_min_clk		( min_clk		),
				.o_hour_clk		( hour_clk		),
				.o_alarm_sec_clk	( alarm_sec_clk		),
				.o_alarm_min_clk	( alarm_min_clk		),
				.o_alarm_hour_clk	( alarm_hour_clk	),
				.o_timer_sec_clk	( timer_sec_clk		),
				.o_timer_min_clk	( timer_min_clk		),
				.o_timer_hour_clk	( timer_hour_clk	),
				.o_date_day_clk		( date_day_clk		),
				.o_date_month_clk	( date_month_clk	),
				.o_date_year_clk	( date_year_clk		),
				.i_max_hit_clock_sec	( max_hit_clock_sec	),
				.i_max_hit_clock_min	( max_hit_clock_min	),
				.i_max_hit_clock_hour	( max_hit_clock_hour	),
				.i_max_hit_alarm_sec	( max_hit_alarm_sec	),
				.i_max_hit_alarm_min	( max_hit_alarm_min	),
				.i_max_hit_alarm_hour	( max_hit_alarm_hour	),
				.i_max_hit_timer_sec	( max_hit_timer_sec	),
				.i_max_hit_timer_min	( max_hit_timer_min	),
				.i_max_hit_timer_hour	( max_hit_timer_hour	),
				.i_max_hit_date_day	( max_hit_date_day	),
				.i_max_hit_date_month	( max_hit_date_month	),
				.i_max_hit_date_year	( max_hit_date_year	),
				.i_sw0			( i_sw0			),
				.i_sw1			( i_sw1			),
				.i_sw2			( i_sw2			),
				.i_sw3			( i_sw3			),
				.clk			  ( clk			),
				.rst_n			( rst_n			));


wire	[5:0]	min_double_fig	;
wire	[5:0]	sec_double_fig	;
wire	[5:0]	hour_double_fig	;

wire	 	    alarm			;
wire       alarm_ontime ;
wire	[5:0]	i_clock_sec		;
wire	[5:0]	i_clock_min		;
wire	[5:0]	i_clock_hour		;
wire	[5:0]	i_alarm_sec		;
wire	[5:0]	i_alarm_min		;
wire	[5:0]	i_alarm_hour		;
wire	[5:0]	i_date_day		;
wire	[5:0]	i_date_month		;
wire	[5:0]	i_date_year		;
minsec		u_minsec(	.o_sec			( sec_double_fig 	),
				.o_min			( min_double_fig 	),
				.o_hour			( hour_double_fig	),
				.o_clock_sec		( i_clock_sec		),
				.o_clock_min		( i_clock_min		),
				.o_clock_hour		( i_clock_hour		),
				.o_alarm_sec		( i_alarm_sec		),
				.o_alarm_min		( i_alarm_min		),
				.o_alarm_hour		( i_alarm_hour		),
				.o_date_day		( i_date_day		),
				.o_date_month		( i_date_month		),
				.o_date_year		( i_date_year		),
				.o_max_hit_clock_sec	( max_hit_clock_sec	),
				.o_max_hit_clock_min	( max_hit_clock_min	),
				.o_max_hit_clock_hour	( max_hit_clock_hour	),
				.o_max_hit_alarm_sec	( max_hit_alarm_sec	),
				.o_max_hit_alarm_min	( max_hit_alarm_min	),
				.o_max_hit_alarm_hour	( max_hit_alarm_hour	),
			   	.o_max_hit_timer_sec	( max_hit_timer_sec	),
				.o_max_hit_timer_min	( max_hit_timer_min	),
				.o_max_hit_timer_hour	( max_hit_timer_hour	),	
				.o_max_hit_date_day	(max_hit_date_day),
				.o_max_hit_date_month	(max_hit_date_month),
				.o_max_hit_date_year	(max_hit_date_year),
				.o_alarm		( alarm		 	),
				.o_alarm_ontime		( alarm_ontime		 	),
				.i_mode			( mode			),
				.i_position		( position		),
				.i_timer    		( timer   		),
				.i_timer_reset  	(         		),
				.i_sec_clk		( sec_clk		),
				.i_min_clk		( min_clk	 	),
				.i_hour_clk		( hour_clk	 	),
				.i_alarm_sec_clk	( alarm_sec_clk		),
				.i_alarm_min_clk	( alarm_min_clk		),
				.i_alarm_hour_clk	( alarm_hour_clk	),
				.i_alarm_en		( alarm_en		),
				.i_timer_sec_clk	( timer_sec_clk		),
				.i_timer_min_clk	( timer_min_clk		),
				.i_timer_hour_clk	( timer_hour_clk	),
				.i_date_day_clk		( date_day_clk		),
				.i_date_month_clk	( date_month_clk	),
				.i_date_year_clk	( date_year_clk		),
				.i_sw1			( i_sw1			),
				.i_sw2			( i_sw2			),
				.clk			( clk			),
				.rst_n			( rst_n			));



wire	[3:0]	left_min_num	;
wire	[3:0]	right_min_num	;

wire	[3:0]	left_sec_num	;
wire	[3:0]	right_sec_num	;

wire	[3:0]	left_hour_num	;
wire	[3:0]	right_hour_num	;

double_fig_sep	u_double_fig_sep0(	.o_left		( left_hour_num		),
					.o_right	( right_hour_num	),
					.i_double_fig	( hour_double_fig	));

double_fig_sep	u_double_fig_sep1(	.o_left		( left_min_num		),
					.o_right	( right_min_num		),
					.i_double_fig	( min_double_fig	));

double_fig_sep	u_double_fig_sep2(	.o_left		( left_sec_num		),
					.o_right	( right_sec_num		),
					.i_double_fig	( sec_double_fig	));



wire	[6:0]	seg_hour_left	;
wire	[6:0]	seg_hour_right	;

wire	[6:0]	seg_min_left	;
wire	[6:0]	seg_min_right	;

wire	[6:0]	seg_sec_left	;
wire	[6:0]	seg_sec_right	;

fnd_dec		u_fnd_dec_hour0	(	.o_seg		( seg_hour_left		),
					.i_num		( left_hour_num		));

fnd_dec		u_fnd_dec_hour1	(	.o_seg		( seg_hour_right	),
					.i_num		( right_hour_num	));

fnd_dec		u_fnd_dec_min0	(	.o_seg		( seg_min_left		),
					.i_num		( left_min_num		));

fnd_dec		u_fnd_dec_min1	(	.o_seg		( seg_min_right		),
					.i_num		( right_min_num		));

fnd_dec		u_fnd_dec_sec0	(	.o_seg		( seg_sec_left		),
					.i_num		( left_sec_num		));

fnd_dec		u_fnd_dec_sec1	(	.o_seg		( seg_sec_right		),
					.i_num		( right_sec_num		));


wire	[6:0]	o_seg_hour_left	;
wire	[6:0]	o_seg_hour_right;

wire	[6:0]	o_seg_min_left	;
wire	[6:0]	o_seg_min_right	;

wire	[6:0]	o_seg_sec_left	;
wire	[6:0]	o_seg_sec_right	;

seg_blink	u_seg_blink	(	.o_seg_sec_left		(o_seg_sec_left),
					.o_seg_sec_right	(o_seg_sec_right),
					.o_seg_min_left		(o_seg_min_left),
					.o_seg_min_right	(o_seg_min_right),
					.o_seg_hour_left	(o_seg_hour_left),
					.o_seg_hour_right	(o_seg_hour_right),
					.i_seg_sec_left		(seg_sec_left),
					.i_seg_sec_right	(seg_sec_right),
					.i_seg_min_left		(seg_min_left),
					.i_seg_min_right	(seg_min_right),
					.i_seg_hour_left	(seg_hour_left),
					.i_seg_hour_right	(seg_hour_right),
					.i_clock_sec		( i_clock_sec		),
					.i_clock_min		( i_clock_min		),
					.i_clock_hour		( i_clock_hour		),
					.i_alarm_sec		( i_alarm_sec		),
					.i_alarm_min		( i_alarm_min		),
					.i_alarm_hour		( i_alarm_hour		),
					.i_position		( position),
					.i_mode			( mode		),
					.clk			(clk),
					.rst_n			( rst_n		));

wire	[41:0]	six_digit_seg	;
assign	six_digit_seg = {o_seg_hour_left, o_seg_hour_right, o_seg_min_left, o_seg_min_right, o_seg_sec_left, o_seg_sec_right};

led_disp	u_led_disp(	.o_seg		( o_seg		),
				.o_seg_dp	( o_seg_dp	),
				.o_seg_enb	( o_seg_enb	),
				.i_six_digit_seg( six_digit_seg	),
				.i_six_dp	( dp		),
				.i_blink_position( position	),
				.clk		( clk		),
				.rst_n		( rst_n		));
// led_disp_timer_reset
buzz_mux    u_buzz_mux(
               .o_buzz_mux     ( o_buzz_mux   ),
               .i_buzz_en      ( alarm        ),
               .i_buzz_en0     ( alarm_ontime ),
               .clk            ( clk          ),
               .rst_n          ( rst_n        ));





endmodule









