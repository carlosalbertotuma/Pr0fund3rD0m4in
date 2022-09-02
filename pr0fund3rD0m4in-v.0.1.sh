#!/bin/bash
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
echo ":::'########::::'#####:::'##::::'##:'##::::::::'####:'##::: ##::::::::::'##::::'##::::::::'#####:::::::::::'##:::::::::"
echo "::: ##.... ##::'##.. ##:: ###::'###: ##:::'##::. ##:: ###:: ##:::::::::: ##:::: ##:::::::'##.. ##::::::::'####:::::::::"
echo "::: ##:::: ##:'##:::: ##: ####'####: ##::: ##::: ##:: ####: ##:::::::::: ##:::: ##::::::'##:::: ##:::::::.. ##:::::::::"
echo "::: ##:::: ##: ##:::: ##: ## ### ##: ##::: ##::: ##:: ## ## ##:'#######: ##:::: ##:::::: ##:::: ##::::::::: ##:::::::::"
echo "::: ##:::: ##: ##:::: ##: ##. #: ##: #########:: ##:: ##. ####:........:. ##:: ##::::::: ##:::: ##::::::::: ##:::::::::"
echo "::: ##:::: ##:. ##:: ##:: ##:.:: ##:...... ##::: ##:: ##:. ###:::::::::::. ## ##:::'###:. ##:: ##::'###:::: ##:::::::::"
echo "::: ########:::. #####::: ##:::: ##::::::: ##::'####: ##::. ##::::::::::::. ###:::: ###::. #####::: ###::'######:::::::"
echo ":::........:::::.....::::..:::::..::::::::..:::....::..::::..::::::::::::::...:::::...::::.....::::...:::......::::::::"
echo
echo
echo "            _   _   _   _   _   _   _   _ "
echo "           / \ / \ / \ / \ / \ / \ / \ / \ "
echo "Creditos: ( B | l | 4 | d | s | c | 4 | n )"
echo "           \_/ \_/ \_/ \_/ \_/ \_/ \_/ \_/ "
echo
echo
echo -e "\e[1;20;50mLivre uso e modificao, mantenha os creditos em comentario.\e[0m"
echo -e "\e[1;31;50mPs: Nao realize teste em dominios sem permissao\e[0m"

}

rm ok.txt ok2.txt ok3.txt ok4.tx dif1 dif2 full-links1-$1.txt full-links2-$1.txt full-links3-$1.txt full-links4-$1.txt 2>/dev/null 1>/dev/null

banner

echo "################   Recon etapa 1 #####################" 
wget2 --robots=off --force-html --spider -r $1 -T 1 -t 1 -nc | grep -Eo '(http|https?|ftp|file)://[-[:alnum:]\+&@#/%?=~_|!:,.;]*[-[:alnum:]\+&@#/%=~_|]' |  tee -a ok.txt

echo "################ Recon etapa 2 ######################" 
cat ok.txt | sort -u | tee -a full-links1-$1.txt | grep $1 | xargs -I %  wget2 -T 1 -t 1 -nc --robots=off --force-html --spider -r % | grep -Eo '(http|https?|ftp|file)://[-[:alnum:]\+&@#/%?=~_|!:,.;]*[-[:alnum:]\+&@#/%=~_|]' | tee ok2.txt 

echo "############### Recon etapa 3 ######################" 
#| grep -Eo "[>].*" | cut -d ">" -f 2

cat ok.txt ok2.txt | sort -u > full-links2-$1.txt
sdiff -s -B -W <(sort ok.txt) <(sort ok2.txt) | cut -d ">" -f 2 | sort -u | grep -Eo "[http|http].*" > dif1
cat dif1 | grep $1 | xargs -I %  wget2 -T 1 -t 1 -nc --robots=off --force-html --spider -r % | grep -Eo '(http|https?|ftp|file)://[-[:alnum:]\+&@#/%?=~_|!:,.;]*[-[:alnum:]\+&@#/%=~_|]' | tee -a ok3.txt 

echo "############## Recon etapa 4 #######################" 
cat full-links2-$1.txt full-links1-$1.txt | sort -u > full-links3-$1.txt 
sdiff -s -B -W <(sort full-links2-$1.txt) <(sort ok3.txt) | cut -d ">" -f 2 | sort -u | grep -Eo "[http|http].*" > dif2
cat dif2 | sort -u | grep $1 | xargs -I %  wget2 -T 1 -t 1 -nc --robots=off --force-html --spider -r % | grep -Eo '(http|https?|ftp|file)://[-[:alnum:]\+&@#/%?=~_|!:,.;]*[-[:alnum:]\+&@#/%=~_|]' | tee -a ok4.txt 
cat full-links3-$1.txt ok4.txt | sort -u | tee -a full-links4-$1.txt | grep $1 > full-so-links-$1.txt
rm ok.txt ok2.txt ok3.txt ok4.tx dif1 dif2 full-links1-$1.txt full-links2-$1.txt full-links3-$1.txt 2>/dev/null 1>/dev/null
echo "############# Fim do Recon ##########################"
