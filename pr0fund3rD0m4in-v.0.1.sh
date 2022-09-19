#!/bin/bash
ua="--user-agent='(Mozilla/5.0 (Windows NT 6.1; rv:45.0) Gecko/20100101 Firefox/45.0)'"
b="--chunk-size=1" # erros de Segmentation fault
banner()
{
echo ":::::::::::'########::'########::::'#####:::'########:'##::::'##:'##::: ##:'########:::'#######::'########:::::::::::::"
echo "::'##:::::: ##.... ##: ##.... ##::'##.. ##:: ##.....:: ##:::: ##: ###:: ##: ##.... ##:'##.... ##: ##.... ##::::::'##:::"
echo ":: ##:::::: ##:::: ##: ##:::: ##:'##:::: ##: ##::::::: ##:::: ##: ####: ##: ##:::: ##:..::::: ##: ##:::: ##:::::: ##:::"
echo "'######:::: ########:: ########:: ##:::: ##: ######::: ##:::: ##: ## ## ##: ##:::: ##::'#######:: ########:::::'######:"
echo ".. ##.::::: ##.....::: ##.. ##::: ##:::: ##: ##...:::: ##:::: ##: ##. ####: ##:::: ##::...... ##: ##.. ##::::::.. ##.::"
echo ":: ##:::::: ##:::::::: ##::. ##::. ##:: ##:: ##::::::: ##:::: ##: ##:. ###: ##:::: ##:'##:::: ##: ##::. ##::::::: ##:::"
echo "::..::::::: ##:::::::: ##:::. ##::. #####::: ##:::::::. #######:: ##::. ##: ########::. #######:: ##:::. ##::::::..::::"
echo ":::::::::::..:::::::::..:::::..::::.....::::..:::::::::.......:::..::::..::........::::.......:::..:::::..:::::::::::::"
echo ":::'########:::'#######::'##::::'##:'##::::::::'####:'##::: ##::::::::::'##::::'##::::::::'#####:::::::::'#######::::::"
echo "::: ##.... ##:'##.... ##: ###::'###: ##:::'##::. ##:: ###:: ##:::::::::: ##:::: ##:::::::'##.. ##:::::::'##.... ##:::::"
echo "::: ##:::: ##: ##:::: ##: ####'####: ##::: ##::: ##:: ####: ##:::::::::: ##:::: ##::::::'##:::: ##::::::..::::: ##:::::"
echo "::: ##:::: ##: ##:::: ##: ## ### ##: ##::: ##::: ##:: ## ## ##:'#######: ##:::: ##:::::: ##:::: ##:::::::'#######::::::"
echo "::: ##:::: ##: ##:::: ##: ##. #: ##: #########:: ##:: ##. ####:........:. ##:: ##::::::: ##:::: ##::::::'##::::::::::::"
echo "::: ##:::: ##: ##:::: ##: ##:.:: ##:...... ##::: ##:: ##:. ###:::::::::::. ## ##:::'###:. ##:: ##::'###: ##::::::::::::"
echo "::: ########::. #######:: ##:::: ##::::::: ##::'####: ##::. ##::::::::::::. ###:::: ###::. #####::: ###: #########:::::"
echo ":::........::::.......:::..:::::..::::::::..:::....::..::::..::::::::::::::...:::::...::::.....::::...::.........::::::"
echo
echo
echo "            _   _   _   _   _   _   _   _ "
echo "           / \ / \ / \ / \ / \ / \ / \ / \ "
echo "Creditos: ( B | l | 4 | d | s | c | 4 | n )"
echo "           \_/ \_/ \_/ \_/ \_/ \_/ \_/ \_/ "
echo
echo -e "\e[31mDesenvolvido: Carlos Tuma - Pentester - RedTeam - BugHunter\e[0m"
echo -e "\e[34mLivre uso e modificao, mantenha os creditos em comentario.\e[0m"
echo -e "\e[38mPs: Nao realize teste em dominios sem permissao\e[0m"

}

banner2()
{
echo -e "\e[33mUse para lista de dominio "-l": bash Pr0fund3r-D0m4in-v.0.2.sh lista.txt nomearquivo -l\e[0m"
echo -e "\e[33mUse para dominio unico "-d": bash Pr0fund3r-D0m4in-v.0.2.sh vulnweb.com nomearquivo -d\e[0m"

}


if [ -z "$1" ];
then
    banner
    banner2
    exit;
elif [ -z "$2" ];
then
    banner
    banner2
    exit;
elif [ -z "$3" ];
then
     banner
     exit;
fi


rm ok.txt ok2.txt ok3.txt ok4.txt dif1 dif2 1>/dev/null 2>/dev/null 
rm debug1-$2 debug2-$2 debug3-$2 debug4-$2 1>/dev/null 2>/dev/null

#banner

if [[ $3 == "-l" ]]
then
echo -e "\e[33m################   Recon etapa 1 ##################### ok\e[0m" 

    for i in $(cat $1);do wget2 --force-sitemap on $b --force-html --spider -r $i $ua -T 1 -t 1 -nc 2>/dev/null | tee -a debug1-$2 | grep -Eo '(http|https?|ftp|file)://[-[:alnum:]\+&@#/%?=~_|!:,.;]*[-[:alnum:]\+&@#/%=~_|]' |  tee -a ok.txt;done

    echo -e "\e[33m################ Recon etapa 2 ###################### ok\e[0m" 
    for i in $(cat $1);do cat ok.txt | sort -u | grep $i | wget2 -T 1 -t 1 -nc $ua $b --force-html --spider -r $i 2>/dev/null | tee -a debug2-$2 | grep -Eo '(http|https?|ftp|file)://[-[:alnum:]\+&@#/%?=~_|!:,.;]*[-[:alnum:]\+&@#/%=~_|]' | tee ok2.txt;done 

    echo -e "\e[33m############### Recon etapa 3 ###################### ok\e[0m" 
    cat ok.txt ok2.txt | sort -u > full-$2.txt
    diff -Z  <(sort -u ok.txt) <(sort -u ok2.txt) | grep \>  | grep -Eo "[http|https].*" > dif1
    for i in $(cat $1);do cat dif1 | grep $i | wget2 -T 1 -t 1 -nc $b $ua --robots=off --force-html --spider -r $i 2>/dev/null | tee -a debug3-$2 | grep -Eo '(http|https?|ftp|file)://[-[:alnum:]\+&@#/%?=~_|!:,.;]*[-[:alnum:]\+&@#/%=~_|]' | tee -a ok3.txt;done 

    echo -e "\e[33m############## Recon etapa 4 ####################### ok\e[0m" 
    diff -Z full-$2.txt <(sort -u ok3.txt) | grep \> | grep -Eo "[http|https].*" > dif2
    cat ok3.txt | sort -u | anew full-$2.txt
    for i in $(cat $1);do cat dif2 | sort -u | grep $i | wget2 -T 1 -t 1 -nc $b $ua --robots=off --force-html --spider -r $i 2>/dev/null | tee -a debug4-$2 | grep -Eo '(http|https?|ftp|file)://[-[:alnum:]\+&@#/%?=~_|!:,.;]*[-[:alnum:]\+&@#/%=~_|]' | tee -a ok4.txt;done 
    cat ok4.txt  | sort -u | anew full-$2.txt 
    for i in $(cat $1);do cat full-$2.txt | grep $i | anew full-links-$2.txt;done



elif [[ $3 == "-d" ]]
then 
    echo -e "\e[33m################   Recon etapa 1 ##################### ok\e[0m" 

    wget2 --force-sitemap on $b --force-html --spider -r $1 $ua -T 1 -t 1 -nc 2>/dev/null | tee -a debug1-$2 | grep -Eo '(http|https?|ftp|file)://[-[:alnum:]\+&@#/%?=~_|!:,.;]*[-[:alnum:]\+&@#/%=~_|]' |  tee -a ok.txt

    echo -e "\e[33m################ Recon etapa 2 ###################### ok\e[0m" 
    cat ok.txt | sort -u | grep $1 | xargs -I %  wget2 -T 1 -t 1 -nc $ua $b --force-html --spider -r % 2>/dev/null | tee -a debug2-$2 | grep -Eo '(http|https?|ftp|file)://[-[:alnum:]\+&@#/%?=~_|!:,.;]*[-[:alnum:]\+&@#/%=~_|]' | tee ok2.txt 

    echo -e "\e[33m############### Recon etapa 3 ###################### ok\e[0m" 
    cat ok.txt ok2.txt | sort -u > full-$2.txt
    diff -Z  <(sort -u ok.txt) <(sort -u ok2.txt) | grep \>  | grep -Eo "[http|https].*" > dif1
    cat dif1 | grep $1 | xargs -I %  wget2 -T 1 -t 1 -nc $b $ua --robots=off --force-html --spider -r % 2>/dev/null | tee -a debug3-$2 | grep -Eo '(http|https?|ftp|file)://[-[:alnum:]\+&@#/%?=~_|!:,.;]*[-[:alnum:]\+&@#/%=~_|]' | tee -a ok3.txt 

    echo -e "\e[33m############## Recon etapa 4 ####################### ok\e[0m" 
    diff -Z full-$2.txt <(sort -u ok3.txt) | grep \> | grep -Eo "[http|https].*" > dif2
    cat ok3.txt | sort -u | anew full-$2.txt
    cat dif2 | sort -u | grep $1 | xargs -I %  wget2 -T 1 -t 1 -nc $b $ua --robots=off --force-html --spider -r % 2>/dev/null | tee -a debug4-$2 | grep -Eo '(http|https?|ftp|file)://[-[:alnum:]\+&@#/%?=~_|!:,.;]*[-[:alnum:]\+&@#/%=~_|]' | tee -a ok4.txt 
    cat ok4.txt  | sort -u | anew full-$2.txt 
    cat full-$2.txt | grep $1 > full-links-$2.txt


else
   exit;
fi

echo -e "\e[33m############# Fim do Recon ##########################\e[0m"
