printf "mv_eth," && less mv_eth_n2_p32_2000 | grep "taken for computation" | cut -f 3,15 -d " " | sort -n | tail -n 1
printf "mv_eth," && less mv_eth_n2_p32_4000 | grep "taken for computation" | cut -f 3,15 -d " " | sort -n | tail -n 1
printf "mv_eth," && less mv_eth_n2_p32_6000 | grep "taken for computation" | cut -f 3,15 -d " " | sort -n | tail -n 1
printf "mv_eth," && less mv_eth_n2_p32_8000 | grep "taken for computation" | cut -f 3,15 -d " " | sort -n | tail -n 1
printf "mv_eth," && less mv_eth_n2_p32_10000 | grep "taken for computation" | cut -f 3,15 -d " " | sort -n | tail -n 1
printf "mv_ib," && less mv_ib_n2_p32_2000 | grep "taken for computation" | cut -f 3,15 -d " " | sort -n | tail -n 1
printf "mv_ib," && less mv_ib_n2_p32_4000 | grep "taken for computation" | cut -f 3,15 -d " " | sort -n | tail -n 1
printf "mv_ib," && less mv_ib_n2_p32_6000 | grep "taken for computation" | cut -f 3,15 -d " " | sort -n | tail -n 1
printf "mv_ib," && less mv_ib_n2_p32_8000 | grep "taken for computation" | cut -f 3,15 -d " " | sort -n | tail -n 1
printf "mv_ib," && less mv_ib_n2_p32_10000 | grep "taken for computation" | cut -f 3,15 -d " " | sort -n | tail -n 1
printf "op_eth," && less op_opt_eth_n2_p32_2000 | grep "taken for computation" | cut -f 3,15 -d " " | sort -n | tail -n 1
printf "op_eth," && less op_opt_eth_n2_p32_4000 | grep "taken for computation" | cut -f 3,15 -d " " | sort -n | tail -n 1
printf "op_eth," && less op_opt_eth_n2_p32_6000 | grep "taken for computation" | cut -f 3,15 -d " " | sort -n | tail -n 1
printf "op_eth," && less op_opt_eth_n2_p32_8000 | grep "taken for computation" | cut -f 3,15 -d " " | sort -n | tail -n 1
printf "op_eth," && less op_opt_eth_n2_p32_10000 | grep "taken for computation" | cut -f 3,15 -d " " | sort -n | tail -n 1
printf "op_ib," && less op_opt_n2_p32_2000 | grep "taken for computation" | cut -f 3,15 -d " " | sort -n | tail -n 1
printf "op_ib," && less op_opt_n2_p32_4000 | grep "taken for computation" | cut -f 3,15 -d " " | sort -n | tail -n 1
printf "op_ib," && less op_opt_n2_p32_6000 | grep "taken for computation" | cut -f 3,15 -d " " | sort -n | tail -n 1
printf "op_ib," && less op_opt_n2_p32_8000 | grep "taken for computation" | cut -f 3,15 -d " " | sort -n | tail -n 1
printf "op_ib," && less op_opt_n2_p32_10000 | grep "taken for computation" | cut -f 3,15 -d " " | sort -n | tail -n 1
