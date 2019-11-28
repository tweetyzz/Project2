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
		clk,
		rst_n);

output	[5:0]	o_seg_enb		;
output		o_seg_dp		;
output	[6:0]	o_seg			;

input	[41:0]	i_six_digit_seg		;
input	[5:0]	i_six_dp		;
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
//	HMS(Hour:Min:Sec) Counter
//	--------------------------------------------------
module	hms_cnt(
		o_hms_cnt,
		o_max_hit,
		i_max_cnt,
		clk,
		rst_n);

output	[5:0]	o_hms_cnt		;
output		o_max_hit		;

input	[5:0]	i_max_cnt		;
input		clk			;
input		rst_n			;

reg	[5:0]	o_hms_cnt		;
reg		o_max_hit		;
always @(posedge clk or negedge rst_n) begin
	if(rst_n == 1'b0) begin
		o_hms_cnt <= 6'd0;
		o_max_hit <= 1'b0;
	end else begin
		if(o_hms_cnt >= i_max_cnt) begin
			o_hms_cnt <= 6'd0;
			o_max_hit <= 1'b1;
		end else begin
			o_hms_cnt <= o_hms_cnt + 1'b1;
			o_max_hit <= 1'b0;
		end
	end
end

endmodule

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
		o_sec_clk,
		o_min_clk,
		o_hour_clk,
		o_alarm_sec_clk,
		o_alarm_min_clk,
		o_alarm_hour_clk,
		i_max_hit_clock_sec,
		i_max_hit_clock_min,
		i_max_hit_clock_hour,
		i_max_hit_alarm_sec,
		i_max_hit_alarm_min,
		i_max_hit_alarm_hour,
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
output		o_sec_clk		;
output		o_min_clk		;
output		o_hour_clk		;
output		o_alarm_sec_clk		;
output		o_alarm_min_clk		;
output		o_alarm_hour_clk	;

input		i_max_hit_clock_sec	;
input		i_max_hit_clock_min	;
input		i_max_hit_clock_hour	;

input		i_max_hit_alarm_sec	;
input		i_max_hit_alarm_min	;
input		i_max_hit_alarm_hour	;

input		i_sw0			;
input		i_sw1			;
input		i_sw2			;
input		i_sw3			;

input		clk			;
input		rst_n			;


parameter	MODE_CLOCK = 2'b00	;
parameter	MODE_SETUP = 2'b01	;
parameter	MODE_ALARM = 2'b10	;


parameter	POS_SEC	= 2'b00		;
parameter	POS_MIN	= 2'b01		;
parameter	POS_HOUR= 2'b10		;//?? ?? ?? 

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

reg	[1:0]	o_mode			;
reg	[5:0]	o_dp			;
always @(posedge sw0 or negedge rst_n) begin
	if(rst_n == 1'b0) begin
		o_mode <= MODE_CLOCK;
		o_dp   <= 6'b010101;	// time dot
	end else begin
		if(o_mode >= MODE_ALARM) begin
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
		end
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
				POS_SEC  : begin
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
		default: begin
			o_sec_clk = 1'b0;
			o_min_clk = 1'b0;
			o_hour_clk= 1'b0;
			o_alarm_sec_clk = 1'b0;
			o_alarm_min_clk = 1'b0;
			o_alarm_hour_clk= 1'b0;

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
		o_max_hit_clock_sec,
		o_max_hit_clock_min,
		o_max_hit_clock_hour,	
		o_max_hit_alarm_sec,
		o_max_hit_alarm_min,
		o_max_hit_alarm_hour,	
		o_alarm,
		i_mode,
		i_position,
		i_sec_clk,
		i_min_clk,
		i_hour_clk,
		i_alarm_sec_clk,
		i_alarm_min_clk,
		i_alarm_hour_clk,
		i_alarm_en,
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

input	[1:0]	i_mode		;
input		i_position	;
input		i_sec_clk	;
input		i_min_clk	;
input		i_hour_clk	;
input		i_alarm_sec_clk	;
input		i_alarm_min_clk	;
input		i_alarm_hour_clk;
input		i_alarm_en	;

input		clk		;
input		rst_n		;

parameter	MODE_CLOCK	= 2'b00	;
parameter	MODE_SETUP	= 2'b01	;
parameter	MODE_ALARM	= 2'b10	;

parameter	POS_SEC		= 2'b00	;
parameter	POS_MIN		= 2'b01	;
parameter	POS_HOUR	= 2'b10	;

wire	[5:0]	clock_sec	;
hms_cnt		u0_hms_cnt(
		.o_hms_cnt	( clock_sec		),
		.o_max_hit	( o_max_hit_clock_sec	),
		.i_max_cnt	( 6'd59			),
		.clk		( i_sec_clk		),
		.rst_n		( rst_n			));

wire	[5:0]	clock_min	;
hms_cnt		u1_hms_cnt(
		.o_hms_cnt	( clock_min	),
		.o_max_hit	( o_max_hit_clock_min	),
		.i_max_cnt	( 6'd59			),
		.clk		( i_min_clk		),
		.rst_n		( rst_n			));


wire	[5:0]	clock_hour	;
hms_cnt		u2_hms_cnt(
		.o_hms_cnt	( clock_hour		),
		.o_max_hit	( o_max_hit_clock_hour	),
		.i_max_cnt	( 6'd23			),
		.clk		( i_hour_clk		),
		.rst_n		( rst_n			));

//	MODE_ALARM
wire	[5:0]	alarm_sec	;
hms_cnt		u_hms_cnt_alarm_sec(
		.o_hms_cnt	( alarm_sec		),
		.o_max_hit	( o_max_hit_alarm_sec	),
		.i_max_cnt	( 6'd59			),
		.clk		( i_alarm_sec_clk	),
		.rst_n		( rst_n			));

wire	[5:0]	alarm_min	;
hms_cnt		u_hms_cnt_alarm_min(
		.o_hms_cnt	( alarm_min		),
		.o_max_hit	( o_max_hit_alarm_min	),
		.i_max_cnt	( 6'd59			),
		.clk		( i_alarm_min_clk	),
		.rst_n		( rst_n			));

wire	[5:0]	alarm_hour	;
hms_cnt		u_hms_cnt_alarm_hour(
		.o_hms_cnt	( alarm_hour		),
		.o_max_hit	( o_max_hit_alarm_hour	),
		.i_max_cnt	( 6'd23			),
		.clk		( i_alarm_hour_clk	),
		.rst_n		( rst_n			));

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
		.i_nco_num	( 25000000	),
		.clk		( clk		),
		.rst_n		( rst_n		));

reg	[4:0]	cnt		;
always @ (posedge clk_bit or negedge rst_n) begin
	if(rst_n == 1'b0) begin
		cnt <= 6'd0;
	end else if(i_buzz_en == 1'b0) begin
	    cnt <= 6'd0 ;
	    end else begin
		if(cnt >= 6'd40) begin
			cnt <= 6'd0;
		end else begin
			cnt <= cnt + 1'd1;
		end
	end
end

reg	[63:0]	nco_num		;
always @ (*) begin
	case(cnt)
		6'd00: nco_num = G	; 
		6'd01: nco_num = B	;
		6'd02: nco_num = D0	; //
		6'd03: nco_num = F1	;
		6'd04: nco_num = G0 ;
		6'd05: nco_num = F1	;
		6'd06: nco_num = E0	; //start
		6'd07: nco_num = D0	;
		
		6'd08: nco_num = A0	;
		6'd09: nco_num = G0	;
		6'd10: nco_num = G0	;
		6'd11: nco_num = F1	;
		6'd12: nco_num = G0	;
		6'd13: nco_num = F1	; 
		6'd14: nco_num = E0	;
		6'd15: nco_num = D0	;
		
		6'd16: nco_num = C0	; //
		6'd17: nco_num = E0	;
		6'd18: nco_num = G0	; //
		6'd19: nco_num = A0	;
		6'd20: nco_num = B0	;
		6'd21: nco_num = A0	; 
		6'd22: nco_num = G0	; //
		6'd23: nco_num = E0	;
		
		6'd24: nco_num = B0	;
		6'd25: nco_num = D1	;
		6'd26: nco_num = B0	;
		6'd27: nco_num = A0	;
		6'd28: nco_num = G0	; //
		6'd29: nco_num = A0	;
		6'd30: nco_num = G0	;
		6'd31: nco_num = E2	;
		6'd32: nco_num = D0	; //
		
		6'd33: nco_num = G0	;
		6'd34: nco_num = A0	;
		6'd35: nco_num = F1	;
		6'd36: nco_num = G0	;
		6'd37: nco_num = E0	;
		6'd38: nco_num = F1	;
		6'd39: nco_num = E2	;
		
		
		
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



module	top_hms_clock(
		o_seg_enb,
		o_seg_dp,
		o_seg,
		o_alarm,
		i_sw0,
		i_sw1,
		i_sw2,
		i_sw3,
		clk,
		rst_n);

output	[5:0]	o_seg_enb	;
output		o_seg_dp	;
output	[6:0]	o_seg		;
output		o_alarm		;

input		i_sw0		;
input		i_sw1		;
input		i_sw2		;
input		i_sw3		;
input		clk		;
input		rst_n		;

wire	[1:0]	mode		;
wire	[5:0]	dp		;
wire		position	;

wire		sec_clk		;
wire		min_clk		;
wire		hour_clk	;

wire		max_hit_clock_sec	;
wire		max_hit_clock_min	;
wire		max_hit_clock_hour	;

wire		max_hit_alarm_sec	;
wire		max_hit_alarm_min	;
wire		max_hit_alarm_hour	;

wire		alarm_sec_clk	;
wire		alarm_min_clk	;
wire		alarm_hour_clk	;

wire		alarm_en	;


controller	u_controller(	.o_mode			( mode			),
				.o_dp			( dp			),
				.o_position		( position		),
				.o_alarm_en		( alarm_en		),
				.o_sec_clk		( sec_clk		),
				.o_min_clk		( min_clk		),
				.o_hour_clk		( hour_clk		),
				.o_alarm_sec_clk	( alarm_sec_clk		),
				.o_alarm_min_clk	( alarm_min_clk		),
				.o_alarm_hour_clk	( alarm_hour_clk	),
				.i_max_hit_clock_sec	( max_hit_clock_sec	),
				.i_max_hit_clock_min	( max_hit_clock_min	),
				.i_max_hit_clock_hour	( max_hit_clock_hour	),
				.i_max_hit_alarm_sec	( max_hit_alarm_sec	),
				.i_max_hit_alarm_min	( max_hit_alarm_min	),
				.i_max_hit_alarm_hour	( max_hit_alarm_hour	),
				.i_sw0			( i_sw0			),
				.i_sw1			( i_sw1			),
				.i_sw2			( i_sw2			),
				.i_sw3			( i_sw3			),
				.clk			( clk			),
				.rst_n			( rst_n			));

wire	[5:0]	min_double_fig	;
wire	[5:0]	sec_double_fig	;
wire	[5:0]	hour_double_fig	;

wire		alarm		;

minsec		u_minsec(	.o_sec			( sec_double_fig 	),
				.o_min			( min_double_fig 	),
				.o_hour			( hour_double_fig	),
				.o_max_hit_clock_sec	( max_hit_clock_sec	),
				.o_max_hit_clock_min	( max_hit_clock_min	),
				.o_max_hit_clock_hour	( max_hit_clock_hour	),
				.o_max_hit_alarm_sec	( max_hit_alarm_sec	),
				.o_max_hit_alarm_min	( max_hit_alarm_min	),
				.o_max_hit_alarm_hour	( max_hit_alarm_hour	),
				.o_alarm		( alarm		 	),
				.i_mode			( mode			),
				.i_position		( position		),
				.i_sec_clk		( sec_clk		),
				.i_min_clk		( min_clk	 	),
				.i_hour_clk		( hour_clk	 	),
				.i_alarm_sec_clk	( alarm_sec_clk		),
				.i_alarm_min_clk	( alarm_min_clk		),
				.i_alarm_hour_clk	( alarm_hour_clk	),
				.i_alarm_en		( alarm_en		),
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

wire	[41:0]	six_digit_seg	;
assign	six_digit_seg = {seg_hour_left, seg_hour_right, seg_min_left, seg_min_right, seg_sec_left, seg_sec_right};

led_disp	u_led_disp(	.o_seg		( o_seg		),
				.o_seg_dp	( o_seg_dp	),
				.o_seg_enb	( o_seg_enb	),
				.i_six_digit_seg( six_digit_seg	),
				.i_six_dp	( dp		),
				.clk		( clk		),
				.rst_n		( rst_n		));

buzz		u_buzz	(	.o_buzz		( o_alarm	),
				.i_buzz_en	( alarm		),
				.clk		( clk		),
				.rst_n		( rst_n		));


endmodule






