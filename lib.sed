######################### MATH / UTILS #########################

#4: <LCG>seed a c m#label<GCL> -> <LCG>new_seed##label<GCL>
:lcg_pos
	s:(<LCG>)([0-9]+ [0-9]+):\1<MULT>\2#result_mpp_lcgp<TLUM>:
	b mult_pos
	:result_mpp_lcgp
		s:(<LCG>)<MULT>([0-9]+)[^<]+<TLUM>:\1\2:
	s:(<LCG>)([0-9]+) ([0-9]+):\1<ADD>\3 \2#result_ap_lcgp<DDA>:
	b add_pos
	:result_ap_lcgp
		s:(<LCG>)<ADD>([0-9]+)[^<]+<DDA>:\1\2:
	s:(<LCG>)([0-9]+ [0-9]+):\1<MOD>\2#result_mdp_lcgp<DOM>:
	b mod_pos
	:result_mdp_lcgp
		s:(<LCG>)<MOD>([0-9]+)[^<]+<DOM>:\1\2#:
b redirect


#2: <INTERSECTION>3 4 5,2 3 4 5 6 7 8#label<NOITCESRETNI> -> <INTERSECTION>1##label<NOITCESRETNI>
:intersection_pos
	s:(<INTERSECTION>)([^,]+):\1!\2 :
	:loop_isp
		/<INTERSECTION>[^!]+!,/{
			s:(<INTERSECTION>)[^#]+:\10:
			b print_isp
		}
		/<INTERSECTION>[^!]*!([0-9]+) [^,]*,[^#]*\b\1\b/{
			s:(<INTERSECTION>)[^#]+:\11:
			b print_isp
		}
		s:(<INTERSECTION>[^!]*)!([0-9]+ ):\1\2!:
	b loop_isp
	:print_isp
		s:#[^<]+<NOITCESRETNI>:#&:
b redirect


#2: <SUBSET>3 4 5,2 3 4 5 6 7 8#label<TESBUS> -> <SUBSET>1##label<TESBUS>
:subset_pos
	s:(<SUBSET>)([^,]+):\1!\2 :
	:loop_ssp
		/<SUBSET>[^!]+!,/{
			s:(<SUBSET>)[^#]+:\11:
			b print_ssp
		}
		/<SUBSET>[^!]*!([0-9]+) [^,]*,[^#]*\b\1\b/{
			s:(<SUBSET>[^!]*)!([0-9]+ ):\1\2!:
			b loop_ssp
		}
	s:(<SUBSET>)[^#]+:\10:
	:print_ssp
		s:#[^<]+<TESBUS>:#&:
b redirect


#1+: <SEQ>3-5,2-8,7-7#label<QES> -> <SEQ>3 4 5,2 3 4 5 6 7 8,7##label<QES>
:seq_pos
	s:<SEQ>:&,:
	b next_sp
	:loop_sp
		/,([0-9]+)<INC>\1#[^<]+<CNI>[^<]+<QES>/b next_sp
		b incr_pos
		:result_ip_sp
			s:(<INC>)([0-9]+)#([^<]+<CNI>)([^,#]+)([^<]+<QES>):\1\2\3\4 \2\5:
	b loop_sp
	:next_sp
		s:,[0-9]+<INC>[^<]+<CNI>([^<]+<QES>):,\1:
		/,[0-9]+-[0-9]+[,#][^<]+<QES>/!b print_sp
		s:,([0-9]+)-([0-9]+)([,#][^<]+<QES>):,\2<INC>\1#result_ip_sp<CNI>\1\3:
	b loop_sp
	:print_sp
		s:(<SEQ>),([^#]+)(#[^<]+<QES>):\1\2#\3:
b redirect


#1+: <MAX>1 2 3#label<XAM> -> <MAX>3##label<XAM>
:max_pos
	s:(<MAX>)([0-9]+#):\10 \2:
	s: ?([0-9]+) ([0-9]+)(#[^<]+<XAM>):A\1,\1B\2,\2M\2\3:
	:loop_Mp
		/,0[BM][^<]+<XAM>/b next_Mp
		s:,([0-9]+)(B[^<]+<XAM>):,<DEC>\1#result_dp_Mp1<CED>\2:
		b decr_pos
		:result_dp_Mp1
			s:,<DEC>([0-9]+)#[^<]+<CED>(B[^<]+<XAM>):,\1\2:
		s:,([0-9]+)(M[^<]+<XAM>):,<DEC>\1#result_dp_Mp2<CED>\2:
		b decr_pos
		:result_dp_Mp2
			s:,<DEC>([0-9]+)#[^<]+<CED>(M[^<]+<XAM>):,\1\2:
	b loop_Mp
	:next_Mp
		s:A([0-9]+),[1-9][0-9]*B[0-9]+,0M[0-9]+([^<]+<XAM>):A0,0B0,0M\1\2:
		/<MAX>A/b print_Mp
		s:B[0-9]+,[0-9]+M([0-9]+)([^<]+<XAM>):B\1,\1M\1\2:
		s: ?([0-9]+)A[0-9]+,[0-9]+:A\1,\1:
	b loop_Mp
	:print_Mp
		s:A[0-9]+,[0-9]+B[0-9]+,[0-9]+M([0-9]+):\1:
		s:#[^<]+<XAM>:#&:
b redirect


#1+: <MIN>1 2 3#label<NIM> -> <MIN>1##label<NIM>
:min_pos
        s:(<MIN>)([0-9]+)#:\1\20 \2#:
	s:(<MIN>0)0:\1:
        s: ?([0-9]+) ([0-9]+)(#[^<]+<NIM>):A\1,\1B\2,\2m\2\3:
        :loop_mp
                /,0[Bm][^<]+<NIM>/b next_mp
#compare lengths first before the dec method
                s:,([0-9]+)(B[^<]+<NIM>):,<DEC>\1#result_dp_mp1<CED>\2:
                b decr_pos
                :result_dp_mp1
                        s:,<DEC>([0-9]+)#[^<]+<CED>(B[^<]+<NIM>):,\1\2:
                s:,([0-9]+)(m[^<]+<NIM>):,<DEC>\1#result_dp_mp2<CED>\2:
                b decr_pos
                :result_dp_mp2
                        s:,<DEC>([0-9]+)#[^<]+<CED>(m[^<]+<NIM>):,\1\2:
        b loop_mp
        :next_mp
                s:A([0-9]+),0B[0-9]+,[1-9][0-9]*m[0-9]+([^<]+<NIM>):A0,0B0,0m\1\2:
                /<MIN>A/b print_mp
                s:B[0-9]+,[0-9]+m([0-9]+)([^<]+<NIM>):B\1,\1m\1\2:
                s: ?([0-9]+)A[0-9]+,[0-9]+:A\1,\1:
        b loop_mp
        :print_mp
                s:A[0-9]+,[0-9]+B[0-9]+,[0-9]+m([0-9]+):\1:
                s:#[^<]+<NIM>:#&:
b redirect


#2: <MOD>5 2#label<DOM> -> <MOD>1##label<DOM>
:mod_pos
	s:#[^>]+<DOM>:,0 0,0&:
	:loop_mdp_1
		s:(<MOD>[0-9]+ [0-9]+,)([0-9]+) [0-9]+,[0-9]+:\1\2 \2:
		s:(<MOD>[0-9]+ )([0-9]+),([0-9]+):\1\2,<ADD>\2 \3#result_ap_mdp<DDA>:
		b add_pos
		:result_ap_mdp
			s:<ADD>([0-9]+)[^>]+<DDA>([^>]+<DOM>):\1\2:
		s:<MOD>([0-9]+) [0-9]+,([0-9]+) [0-9]+:&<MIN>\1 \2#result_mp_mdp<NIM>:
		b min_pos
		:result_mp_mdp
			s:<MIN>([0-9]+)[^>]+<NIM>:,\1:
	/<MOD>([0-9]+) [0-9]+,[0-9]+ [0-9]+,\1/!b loop_mdp_1
	/<MOD>([0-9]+) [0-9]+,\1 / s:(<MOD>[0-9]+ [0-9]+),([0-9]+) [0-9]+:\1,\2 \2:
	s:(<MOD>[0-9]+) [0-9]+,[0-9]+ ([0-9]+),[0-9]+:\1,\2 0:
	:loop_mdp_2
		/<MOD>([0-9]+),\1/b print_mdp
		s:(<MOD>)([0-9]+):\1<DEC>\2#result_dp_mdp<CED>:
		b decr_pos
		:result_dp_mdp
			s:<DEC>([0-9]+)[^>]+<CED>:\1:
		s:(<MOD>[0-9]+,[0-9]+ )([0-9]+):\1<INC>\2#result_ip_mdp<CNI>:
		b incr_pos
		:result_ip_mdp
			s:<INC>([0-9]+)[^>]+<CNI>:\1:
	b loop_mdp_2
	:print_mdp
		s:(<MOD>)[0-9]+,[0-9]+ ([0-9]+):\1\2#:
b redirect


#1+: <MULT>2 3 4#label<TLUM> -> <MULT>24##label<TLUM>
:mult_pos
	s:(<MULT>)([0-9]+#):\11 \2:
	:loop_mpp
		/ ?\b0\b ([0-9]+)(#[^<]+<TLUM>)/{
			s:(<MULT>)[^#]+:\1 0:
			b print_mpp
		}
		s: ?([0-9]+) ([0-9]+)(#[^<]+<TLUM>):<ADD>\1 \2#result_ap_mpp<DDA>\3:
		s:(<ADD>)([0-9]+) ([^<]+<DDA>[^<]+<TLUM>):\1<SEQ>1-\2#result_sp_mpp<QES>\3:
		b seq_pos
		:result_sp_mpp
			s:(<SEQ>)[0-9]+ ?([^#]*[^<]+<QES>)([0-9]+):\3 \1\2\3:
		/<SEQ>#/!b result_sp_mpp
		s: <SEQ>[^<]+<QES>[0-9]+::
		b add_pos
		:result_ap_mpp
			s:<ADD>([^#]+)[^<]+<DDA>: \1:
	/<MULT>[0-9]+ /b loop_mpp
	:print_mpp
		s:(<MULT>) :\1:
		s:#[^<]+<TLUM>:#&:
b redirect


#1+: <ADD>1 2 3#label<DDA> -> <ADD>6##label<DDA>
:add_pos
	s:(<ADD>)([0-9]+#):\10 \2:
	s: ?([0-9]+) ([0-9]+)(#[^<]+<DDA>):<DEC>\1#result_dp_ap<CED><INC>\2#result_ip_ap<CNI>\3:
	:loop_ap
		/<DEC>0/b next_ap
		b decr_pos
		:result_dp_ap
			s:#([^<]+<CED>):\1:
		b incr_pos
		:result_ip_ap
			s:#([^<]+<CNI>):\1:
	b loop_ap
	:next_ap
		/<ADD><DEC>/b print_ap
		s: ?([0-9]+)(<DEC>)0:\2\1:
	b loop_ap
	:print_ap
		s:<DEC>0#result_dp_ap<CED><INC>([0-9]+)#result_ip_ap<CNI>(#[^<]+<DDA>):\1#\2:
b redirect


#1: <DEC>10#label<CED> -> <DEC>9##label<CED>
:decr_pos
	:zeros
		s:0(@*)(#[^<]+<CED>):@\1\2:
	t zeros
	s:9(@*)(#[^<]+<CED>):8\1\2:;t print_dp
	s:8(@*)(#[^<]+<CED>):7\1\2:;t print_dp
	s:7(@*)(#[^<]+<CED>):6\1\2:;t print_dp
	s:6(@*)(#[^<]+<CED>):5\1\2:;t print_dp
	s:5(@*)(#[^<]+<CED>):4\1\2:;t print_dp
	s:4(@*)(#[^<]+<CED>):3\1\2:;t print_dp
	s:3(@*)(#[^<]+<CED>):2\1\2:;t print_dp
	s:2(@*)(#[^<]+<CED>):1\1\2:;t print_dp
	s:1(@*)(#[^<]+<CED>):0\1\2:;t print_dp
	:print_dp
		s:(<DEC>)0@:\1@:
		:loop_dp
			s:(<DEC>[^#]*)@:\19:
		/<DEC>[^#]*@/b loop_dp
		s:#[^<]+<CED>:#&:
b redirect


#1: <INC>9#label<CNI> -> <INC>10##label<CNI>
:incr_pos
	:nines
		s:9(@*)(#[^<]+<CNI>):@\1\2:
	t nines
	s:0(@*)(#[^<]+<CNI>):1\1\2:;t print_ip
	s:1(@*)(#[^<]+<CNI>):2\1\2:;t print_ip
	s:2(@*)(#[^<]+<CNI>):3\1\2:;t print_ip
	s:3(@*)(#[^<]+<CNI>):4\1\2:;t print_ip
	s:4(@*)(#[^<]+<CNI>):5\1\2:;t print_ip
	s:5(@*)(#[^<]+<CNI>):6\1\2:;t print_ip
	s:6(@*)(#[^<]+<CNI>):7\1\2:;t print_ip
	s:7(@*)(#[^<]+<CNI>):8\1\2:;t print_ip
	s:8(@*)(#[^<]+<CNI>):9\1\2:;t print_ip
	:print_ip
		s:(<INC>)@:\11@:
		:loop_ip
			s:(<INC>[^#]*)@:\10:
		/<INC>[^#]*@/b loop_ip
		s:#[^<]+<CNI>:#&:
b redirect


:redirect
	b library_redirects
	:continue_redirects
	b user_redirects


:library_redirects
	/##result_mpp_lcgp<TLUM>/b result_mpp_lcgp
	/##result_ap_lcgp<DDA>/b result_ap_lcgp
	/##result_mdp_lcgp<DOM>/b result_mdp_lcgp
	/##result_dp_ap<CED>/b result_dp_ap
	/##result_dp_Mp1<CED>/b result_dp_Mp1
	/##result_dp_Mp2<CED>/b result_dp_Mp2
	/##result_dp_mp1<CED>/b result_dp_mp1
	/##result_dp_mp2<CED>/b result_dp_mp2
	/##result_ap_mdp<DDA>/b result_ap_mdp
	/##result_mp_mdp<NIM>/b result_mp_mdp
	/##result_dp_mdp<CED>/b result_dp_mdp
	/##result_ip_mdp<CNI>/b result_ip_mdp
	/##result_sp_mpp<QES>/b result_sp_mpp
	/##result_ap_mpp<DDA>/b result_ap_mpp
	/##result_ip_ap<CNI>/b result_ip_ap
	/##result_ip_sp<CNI>/b result_ip_sp
b continue_redirects


:EOS
	#End Of Script (mainly used to skip over remaining code, when needed)
