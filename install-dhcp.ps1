# Initialisation des vars
$Inter=""                                               # Interface de la carte réseau
$reqCreaEtendue="n"                                    # Condition pour entrer une nouvelle adresse IP

$nomEtendue=""                                         # Nom de l'étendue
$StartIP=""                                            # Début de l'étendue
$EndIP=""                                              # Fin de l'étendue
$mask=""                                               # MaskCIDR de l'étendue
$desc=""                                               # Description de l'étendue
$state=""                                              # Etat "Active" ou "Desactive" pour l'étendue créée

$ReseauEtendue=""                                      # Adresse Réseau de l'étendue à exclure
$reqCreaExclu=""                                       # Continuer à étendre [o]ui ou [n]on

$i=0                                                   # Compteur

# Affichage des interfaces avec leurs index
Get-NetAdapter

# Installation du service DHCP
Install-WindowsFeature -Name DHCP -IncludeManagementTools -IncludeAllSubFeature

# Création d'un groupe de sécurité pour le service DHCP (obligatoire mais pourqwa ?!)
Add-DhcpServerSecurityGroup

# Demande à l'utilisateur combien d'etenndue il veut creer
$i=Read-Host -Prompt "Combien d'étendue voulez vous créer ? "

while ($i -eq 0) {
    $nomEtendue=Read-Host -Prompt "Nom de l'étendue "
    $StartIP=Read-Host -Prompt "Début de l'adressage IP"
    $EndIP=Read-Host -Prompt "Fin de l'adressage IP "
    $mask=Read-Host -Prompt "Masque de l'étendue en notation CIDR "
    $desc=Read-Host -Prompt "Description de l'étendue "
    $state=Read-Host -Prompt "Etendue à l'état 'Active' ou 'Desactive' "
    

    # Creation de l'etendue
    Add-DhcpServerv4Scope -Name $nomEtendue -StartRange $StartIP -EnRange $EndIP -SubnetMask $mask -Description $desc -State $state
    
    # Demande a l'utilisateur s'il veut creer des exclusions
    $reqCreaExclu=Read-Host -Prompt "Voulez-vous créer une exclusion ? [o]ui ou [n]on "
    while ($reqCreaExclu -eq "o") {
        $StartIP=Read-Host -Prompt "1er adresse disponible à exclure "
        $EndIP=Read-Host -Prompt "Dernière adresse disponible à exclure "
        $ReseauEtendue=Read-Host -Prompt "Adresse Réseau du réseau à étendre "
        Add-DhcpServerv4ExclusionRange -ScopeID $ReseauEtendue -StartRange $StartIP -EndRange $EndIP
        $reqCreaExclu=Read-Host -Prompt "Voulez-vous créer une autre exclusion ? [o]ui ou [n]on "
    }

    $i--
    #$reqCreaEtendue=Read-Host -Prompt "Voulez vous créer une autre étendue ? [o]ui [n]on"
}