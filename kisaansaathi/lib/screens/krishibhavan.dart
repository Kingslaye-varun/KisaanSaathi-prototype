import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class KrishiBhavanScreen extends StatefulWidget {
  const KrishiBhavanScreen({Key? key}) : super(key: key);

  @override
  State<KrishiBhavanScreen> createState() => _KrishiBhavanScreenState();
}

class _KrishiBhavanScreenState extends State<KrishiBhavanScreen> {
  final List<Map<String, String>> officers = [
    {
      'slNo': '1',
      'office': 'Principal Agriculture Officer Kollam',
      'chargeOfficer': 'PRIYAKUMAR.P',
      'designation': 'Agriculture Officer',
      'phone': '4742795082',
      'email': 'principalaokollam@gmail.com',
    },
    {
      'slNo': '2',
      'office': 'Agricultural Officer Krishi Bhavan Pattazhy South Kollam',
      'chargeOfficer': 'SUNIL VARGHESE',
      'designation': 'Agriculture Officer',
      'phone': '9383470253',
      'email': 'kbpattazhisouth@gmail.com',
    },
    {
      'slNo': '3',
      'office': 'Agricultural Officer Krishi Bhavan Pattazhy North Kollam',
      'chargeOfficer': 'SINDHU.',
      'designation': 'Agriculture Officer',
      'phone': '9383470252',
      'email': 'pattazhynorthkb@gmail.com',
    },
    {
      'slNo': '4',
      'office': 'Agricultural Officer Krishi Bhavan Thalavoor Kollam',
      'chargeOfficer': 'JAYAN',
      'designation': 'Agriculture Officer',
      'phone': '9383470237',
      'email': 'kbthalavoor2@gmail.com',
    },
    {
      'slNo': '5',
      'office': 'Agricultural Officer Krishi Bhavan Vilakkudy Kollam',
      'chargeOfficer': 'ANJU',
      'designation': 'Agriculture Officer',
      'phone': '9383470218',
      'email': 'kbvilakkudy@gmail.com',
    },
    {
      'slNo': '6',
      'office': 'Agricultural Officer Krishi Bhavan Punalur Kollam',
      'chargeOfficer': 'P V Sudharsanan',
      'designation': 'Agriculture Officer',
      'phone': '4752230958',
      'email': 'afopunalurkb@gmail.com',
    },
    {
      'slNo': '7',
      'office': 'Agricultural Officer Krishi Bhavan Piravanthoor Kollam',
      'chargeOfficer': 'Soumya B Nair',
      'designation': 'Agriculture Officer',
      'phone': '4742371158',
      'email': 'krishibhavanpvr2013@gmail.com',
    },
    {
      'slNo': '8',
      'office': 'Agricultural Officer Krishi Bhavan Pathanapuram Kollam',
      'chargeOfficer': 'Soumya B Nair',
      'designation': 'Agriculture Officer',
      'phone': '9383470251',
      'email': 'kbpathanapuram@gmail.com',
    },
    {
      'slNo': '9',
      'office': 'Agricultural Officer Krishi Bhavan Sasthamcotta Kollam',
      'chargeOfficer': 'BINISHA',
      'designation': 'Agriculture Officer',
      'phone': '9383470225',
      'email': 'kbsasthamcotta@gmail.com',
    },
    {
      'slNo': '10',
      'office': 'Agricultural Officer Krishi Bhavan Sooranad North Kollam',
      'chargeOfficer': 'Anson',
      'designation': 'Agriculture Officer',
      'phone': '9383470231',
      'email': 'kbsooranadnorth@gmail.com',
    },
    {
      'slNo': '11',
      'office': 'Agricultural Officer Krishi Bhavan Sooranad South Kollam',
      'chargeOfficer': 'BINDUMOL',
      'designation': 'Agriculture Officer',
      'phone': '9383470233',
      'email': 'krishibhavansooranadusouth@gmail.com',
    },
    {
      'slNo': '12',
      'office': 'Agricultural Officer Krishi Bhavan Kunnathur Kollam',
      'chargeOfficer': 'NANDAKUMAR K',
      'designation': 'Agriculture Officer',
      'phone': '9383470227',
      'email': 'kbkunnathoor@gmail.com',
    },
    {
      'slNo': '13',
      'office': 'Agricultural Officer Krishi Bhavan Poruvazhy Kollam',
      'chargeOfficer': 'MOLU T LALSON',
      'designation': 'Agriculture Officer',
      'phone': '9383470229',
      'email': 'kbprvzhyklm.agri@kerala.gov.in',
    },
    {
      'slNo': '14',
      'office': 'Agricultural Officer Krishi Bhavan West Kallada Kollam',
      'chargeOfficer': 'Shital',
      'designation': 'Agriculture Officer',
      'phone': '9383470506',
      'email': 'kboachira@gmail.com',
    },
    {
      'slNo': '15',
      'office': 'Agricultural Officer Krishi Bhavan Mynagappally Kollam',
      'chargeOfficer': 'Aswathy',
      'designation': 'Agriculture Officer',
      'phone': '9383470236',
      'email': 'kbmynagappally@gmail.com',
    },
    {
      'slNo': '16',
      'office': 'Agricultural Officer Krishi Bhavan Chavara Kollam',
      'chargeOfficer': 'PREEJA BALAN',
      'designation': 'Agriculture Officer',
      'phone': '9383470346',
      'email': 'kbchavara@gmail.com',
    },
    {
      'slNo': '17',
      'office': 'Agricultural Officer Krishi Bhavan Thevalakkara Kollam',
      'chargeOfficer': 'SAJU S S',
      'designation': 'Agriculture Officer',
      'phone': '9383470340',
      'email': 'kbtvlkraklm.agri@kerala.gov.in',
    },
    {
      'slNo': '18',
      'office': 'Agricultural Officer Krishi Bhavan Panmana Kollam',
      'chargeOfficer': 'ARYAKRISHNA.',
      'designation': 'Agriculture Officer',
      'phone': '9383470341',
      'email': 'kbpanmana@gmail.com',
    },
    {
      'slNo': '19',
      'office': 'Agricultural Officer Krishi Bhavan Thekkumbhagom Kollam',
      'chargeOfficer': 'Shijina N',
      'designation': 'Agriculture Officer',
      'phone': '9383470342',
      'email': 'kbtkmbgmklm.agri@kerala.gov.in',
    },
    {
      'slNo': '20',
      'office': 'Agricultural Officer Krishi Bhavan Neendakara Kollam',
      'chargeOfficer': 'Sajithamol',
      'designation': 'Agriculture Officer',
      'phone': '9383470344',
      'email': 'kbneendakaraa@gmail.com',
    },
    {
      'slNo': '21',
      'office': 'Agricultural Officer Krishi Bhavan Sakthikulangara Kollam',
      'chargeOfficer': 'FRANCIS CHRISTY',
      'designation': 'Agriculture Officer',
      'phone': '9383470247',
      'email': 'kbsklgraklm.agri@kerala.gov.in',
    },
    {
      'slNo': '22',
      'office': 'Agricultural Officer Krishi Bhavan Mayyanad Kollam',
      'chargeOfficer': 'Anup Chandran C',
      'designation': 'Agriculture Officer',
      'phone': '9383470246',
      'email': 'kbmayyanadu@gmail.com',
    },
    {
      'slNo': '23',
      'office': 'Agricultural Officer Krishi Bhavan Kilikolloor Kollam',
      'chargeOfficer': 'RIAZ.R',
      'designation': 'Agriculture Officer',
      'phone': '9383470243',
      'email': 'kbklklorklm.agri@kerala.gov.in',
    },
    {
      'slNo': '24',
      'office': 'Agricultural Officer Krishi Bhavan Elampalloor Kollam',
      'chargeOfficer': 'Sajithamol',
      'designation': 'Agriculture Officer',
      'phone': '9383470239',
      'email': 'aoelampalloor@gmail.com',
    },
    {
      'slNo': '25',
      'office': 'Agricultural Officer Krishi Bhavan Kottamkara Kollam',
      'chargeOfficer': 'SUBASH.P',
      'designation': 'Agriculture Officer',
      'phone': '9383470245',
      'email': 'aokottamkara@gmail.com',
    },
    {
      'slNo': '26',
      'office': 'Agricultural Officer Krishi Bhavan Vadakkevila Kollam',
      'chargeOfficer': 'SNEHA S MOHAN',
      'designation': 'Agriculture Officer',
      'phone': '9383470249',
      'email': 'kbvadakkevila@gmail.com',
    },
    {
      'slNo': '27',
      'office': 'Agricultural Officer Krishi Bhavan Kollam',
      'chargeOfficer': 'Prakash',
      'designation': 'Agriculture Officer',
      'phone': '4742751212',
      'email': 'kbkollam@gmail.com',
    },
    {
      'slNo': '28',
      'office': 'Agricultural Officer Krishi Bhavan Thrikkovilvattam Kollam',
      'chargeOfficer': 'Anushma',
      'designation': 'Agriculture Officer',
      'phone': '9383470248',
      'email': 'kbthrikkovilvattom@gmail.com',
    },
    {
      'slNo': '29',
      'office': 'Agricultural Officer Krishi Bhavan Eravipuram Kollam',
      'chargeOfficer': 'SEENA',
      'designation': 'Agriculture Officer',
      'phone': '9383470242',
      'email': 'kberavipuram@gmail.com',
    },
    {
      'slNo': '30',
      'office': 'Agricultural Officer Krishi Bhavan Kottarakkara Kollam',
      'chargeOfficer': 'PUSHPARAJAN B',
      'designation': 'Agriculture Officer',
      'phone': '9383470354',
      'email': 'kbkottarakkara@gmail.com',
    },
    {
      'slNo': '31',
      'office': 'Agricultural Officer Krishi Bhavan Neduvathoor Kollam',
      'chargeOfficer': 'SAJAN S THOMAS',
      'designation': 'Agriculture Officer',
      'phone': '9383470350',
      'email': 'kbneduvathoor@gmail.com',
    },
    {
      'slNo': '32',
      'office': 'Agricultural Officer Krishi Bhavan Ezhukone Kollam',
      'chargeOfficer': 'Athira',
      'designation': 'Agriculture Officer',
      'phone': '9383470356',
      'email': 'eknkrishi@gmail.com',
    },
    {
      'slNo': '33',
      'office': 'Agricultural Officer Krishi Bhavan Kareepra Kollam',
      'chargeOfficer': 'SAJEEV',
      'designation': 'Agriculture Officer',
      'phone': '9383470352',
      'email': 'kbkareepra@gmail.com',
    },
    {
      'slNo': '34',
      'office': 'Agricultural Officer Krishi Bhavan Veliyam Kollam',
      'chargeOfficer': 'SNEHA',
      'designation': 'Agriculture Officer',
      'phone': '9383470360',
      'email': 'kbveliyam@gmail.com',
    },
    {
      'slNo': '35',
      'office': 'Agricultural Officer Krishi Bhavan Pooyappally Kollam',
      'chargeOfficer': 'Divya S L',
      'designation': 'Agriculture Officer',
      'phone': '9383470358',
      'email': 'kbpooyappally@gmail.com',
    },
    {
      'slNo': '36',
      'office': 'Agricultural Officer Krishi Bhavan Munroe Island Kollam',
      'chargeOfficer': 'Miya',
      'designation': 'Agriculture Officer',
      'phone': '9383478903',
      'email': 'kbmunroeisland@gmail.com',
    },
    {
      'slNo': '37',
      'office': 'Agricultural Officer Krishi Bhavan East Kallada Kollam',
      'chargeOfficer': 'Anagha PK',
      'designation': 'Agriculture Officer',
      'phone': '9383478901',
      'email': 'kbeastkallada@gmail.com',
    },
    {
      'slNo': '38',
      'office': 'Agricultural Officer Krishi Bhavan Perayam Kollam',
      'chargeOfficer': 'SONAL SALIM',
      'designation': 'Agriculture Officer',
      'phone': '9383478905',
      'email': 'kbperayam@gmail.com',
    },
    {
      'slNo': '39',
      'office': 'Agricultural Officer Krishi Bhavan Kundara Kollam',
      'chargeOfficer': 'Priya',
      'designation': 'Agriculture Officer',
      'phone': '9383487902',
      'email': 'kbkundara@gmail.com',
    },
    {
      'slNo': '40',
      'office': 'Agricultural Officer Krishi Bhavan Perinad Kollam',
      'chargeOfficer': 'Anjana',
      'designation': 'Agriculture Officer',
      'phone': '9383478906',
      'email': 'kbperinad@gmail.com',
    },
    {
      'slNo': '41',
      'office': 'Agricultural Officer Krishi Bhavan Panayam Kollam',
      'chargeOfficer': 'Shamna R',
      'designation': 'Agriculture Officer',
      'phone': '9383478904',
      'email': 'kbpanayam@gmail.com',
    },
    {
      'slNo': '42',
      'office': 'Agricultural Officer Krishi Bhavan Thrikkadavoor Kollam',
      'chargeOfficer': 'A.SUKUMARAN NAIR',
      'designation': 'Agriculture Officer',
      'phone': '9383478908',
      'email': 'kbthrikkadavoor@gmail.com',
    },
    {
      'slNo': '43',
      'office': 'Agricultural Officer Krishi Bhavan Thrikkaruva Kollam',
      'chargeOfficer': 'DARSANA V S LAL',
      'designation': 'Agriculture Officer',
      'phone': '9383478964',
      'email': 'kbthrikkaruva@gmail.com',
    },
    {
      'slNo': '44',
      'office': 'Agricultural Officer Krishi Bhavan Kulakkada Kollam',
      'chargeOfficer': 'SATHEESH KUMAR D',
      'designation': 'Agriculture Officer',
      'phone': '9383470372',
      'email': 'satheesh.ankm@gmail.com',
    },
    {
      'slNo': '45',
      'office': 'Agricultural Officer Krishi Bhavan Melila Kollam',
      'chargeOfficer': 'LIJU',
      'designation': 'Agriculture Officer',
      'phone': '9383470371',
      'email': 'kbmelila@gmail.com',
    },
    {
      'slNo': '46',
      'office': 'Agricultural Officer Krishi Bhavan Mylom Kollam',
      'chargeOfficer': 'CHITHRA K R',
      'designation': 'Agriculture Officer',
      'phone': '9383470357',
      'email': 'kbmylom2012@gmail.com',
    },
    {
      'slNo': '47',
      'office': 'Agricultural Officer Krishi Bhavan Pavithreswaram Kollam',
      'chargeOfficer': 'Naveedha',
      'designation': 'Agriculture Officer',
      'phone': '9383470359',
      'email': 'kbpavithreswarm@gmail.com',
    },
    {
      'slNo': '48',
      'office': 'Agricultural Officer Krishi Bhavan Ummannur Kollam',
      'chargeOfficer': 'SARALA.P B',
      'designation': 'Agriculture Officer',
      'phone': '8547567184',
      'email': 'kbummannoor@gmail.com',
    },
    {
      'slNo': '49',
      'office': 'Agricultural Officer Krishi Bhavan Vettikkavala Kollam',
      'chargeOfficer': 'Abhijith Kumar V P',
      'designation': 'Agriculture Officer',
      'phone': '9383470351',
      'email': 'krishibhavanvtka@gmail.com',
    },
    {
      'slNo': '50',
      'office': 'Agricultural Officer Krishi Bhavan Nedumpana Kollam',
      'chargeOfficer': 'ShamnaR',
      'designation': 'Agriculture Officer',
      'phone': '4742564464',
      'email': 'aonedumpana@gmail.com',
    },
    {
      'slNo': '51',
      'office': 'Agricultural Officer Krishi Bhavan Kalluvathukkal Kollam',
      'chargeOfficer': 'Saliha',
      'designation': 'Agriculture Officer',
      'phone': '9383470210',
      'email': 'aokalluvathukkal@gmail.com',
    },
    {
      'slNo': '52',
      'office': 'Agricultural Officer Krishi Bhavan Chathannur Kollam',
      'chargeOfficer': 'MANOJ LUKOSE',
      'designation': 'Agriculture Officer',
      'phone': '9383470215',
      'email': 'kb6666chathannur@gmail.com',
    },
    {
      'slNo': '53',
      'office': 'Agricultural Officer Krishi Bhavan Adichanallur Kollam',
      'chargeOfficer': 'SUNILKUMAR C P',
      'designation': 'ASSISTANT AGRICULTURAL OFFICER',
      'phone': '2590760',
      'email': 'kbadichanalloor@gmail.com',
    },
    {
      'slNo': '54',
      'office': 'Agricultural Officer Krishi Bhavan Paravoor Kollam',
      'chargeOfficer': 'Sreenath R',
      'designation': 'Agriculture Officer',
      'phone': '9383470224',
      'email': 'kbparavoor@gmail.com',
    },
    {
      'slNo': '55',
      'office': 'Agricultural Officer Krishi Bhavan Poothakulam Kollam',
      'chargeOfficer': 'SREEVALSA P SREENIVASAN',
      'designation': 'Agriculture Officer',
      'phone': '9383470219',
      'email': 'kbpoothakulam@gmail.com',
    },
    {
      'slNo': '56',
      'office': 'Agricultural Officer Krishi Bhavan Chirakkara Kollam',
      'chargeOfficer': 'Anju Vijayan',
      'designation': 'Agriculture Officer',
      'phone': '4742590102',
      'email': 'kbchirakkara@gmail.com',
    },
    {
      'slNo': '57',
      'office': 'Agricultural Officer Krishi Bhavan Chadayamangalam Kollam',
      'chargeOfficer': 'Asa Rani',
      'designation': 'Agriculture Officer',
      'phone': '9383470322',
      'email': 'kbchymlmklm.agri@kerala.gov.in',
    },
    {
      'slNo': '58',
      'office': 'Agricultural Officer Krishi Bhavan Kadakkal Kollam',
      'chargeOfficer': 'Sreejithkumar',
      'designation': 'Agriculture Officer',
      'phone': '9383470326',
      'email': 'kbkadakkal@gmail.com',
    },
    {
      'slNo': '59',
      'office': 'Agricultural Officer Krishi Bhavan Nilamel Kollam',
      'chargeOfficer': 'NASEEM.M',
      'designation': 'Agriculture Officer',
      'phone': '9383470328',
      'email': 'kbnilamel@gmail.com',
    },
    {
      'slNo': '60',
      'office': 'Agricultural Officer Krishi Bhavan Ittiva Kollam',
      'chargeOfficer': 'ARYA M S',
      'designation': 'Agriculture Officer',
      'phone': '9383470325',
      'email': 'kbittiva2012@gmail.com',
    },
    {
      'slNo': '61',
      'office': 'Agricultural Officer Krishi Bhavan Chithara Kollam',
      'chargeOfficer': 'SHAIS.S',
      'designation': 'Agriculture Officer',
      'phone': '9383470323',
      'email': 'kbchthrklm.agri@kerala.gov.in',
    },
    {
      'slNo': '62',
      'office': 'Agricultural Officer Krishi Bhavan Kummil Kollam',
      'chargeOfficer': 'SATHEESH',
      'designation': 'Agriculture Officer',
      'phone': '9383470327',
      'email': 'kbkummilklm.agri@kerala.gov.in',
    },
    {
      'slNo': '63',
      'office': 'Agricultural Officer Krishi Bhavan Elamadu Kollam',
      'chargeOfficer': 'REMYA CHANDRAN R',
      'designation': 'Agriculture Officer',
      'phone': '9383470324',
      'email': 'elamadukb@gmail.com',
    },
    {
      'slNo': '64',
      'office': 'Agricultural Officer Krishi Bhavan Velinalloor Kollam',
      'chargeOfficer': 'Divya',
      'designation': 'Agriculture Officer',
      'phone': '9383470329',
      'email': 'kbvelinalloor@gmail.com',
    },
    {
      'slNo': '65',
      'office': 'Agricultural Officer Krishi Bhavan Oachira Kollam',
      'chargeOfficer': 'Shital Shivankutty',
      'designation': 'Agriculture Officer',
      'phone': '4762698952',
      'email': 'kbochrklm.agri@kerala.gov.in',
    },
    {
      'slNo': '66',
      'office': 'Agricultural Officer Krishi Bhavan Clappana Kollam',
      'chargeOfficer': 'AJMY',
      'designation': 'Agriculture Officer',
      'phone': '9383470212',
      'email': 'krishibhavanclappana@gmail.com',
    },
    {
      'slNo': '67',
      'office': 'Agricultural Officer Krishi Bhavan Kulasekharapuram Kollam',
      'chargeOfficer': 'Meera R',
      'designation': 'Agriculture Officer',
      'phone': '9400729883',
      'email': 'aokspm@gmail.com',
    },
    {
      'slNo': '68',
      'office': 'Agricultural Officer Krishi Bhavan Karunagappally Kollam',
      'chargeOfficer': 'BINDUMOL',
      'designation': 'Agriculture Officer',
      'phone': '9383470214',
      'email': 'aokarunagappally@gmail.com',
    },
    {
      'slNo': '69',
      'office': 'Agricultural Officer Krishi Bhavan Alappad Kollam',
      'chargeOfficer': 'Noobiya',
      'designation': 'Agriculture Officer',
      'phone': '9383470211',
      'email': 'aoalappad@gmail.com',
    },
    {
      'slNo': '70',
      'office': 'Agricultural Officer Krishi Bhavan Thodiyoor Kollam',
      'chargeOfficer': 'KARTHIKA',
      'designation': 'Agriculture Officer',
      'phone': '9383470619',
      'email': 'kbthodiyoor@gmail.com',
    },
    {
      'slNo': '71',
      'office': 'Agricultural Officer Krishi Bhavan Thazhava Kollam',
      'chargeOfficer': 'SONIYA N T',
      'designation': 'Agriculture Officer',
      'phone': '9383470216',
      'email': 'kbtazhvaklm.agri@kerala.gov.in',
    },
    {
      'slNo': '72',
      'office': 'Agricultural Officer Krishi Bhavan Thenmala Kollam',
      'chargeOfficer': 'AJAYAKUMAR.B',
      'designation': 'Agriculture Officer',
      'phone': '9383478958',
      'email': 'kbthenmala@gmail.com',
    },
    {
      'slNo': '73',
      'office': 'Agricultural Officer Krishi Bhavan Yeroor Kollam',
      'chargeOfficer': 'ANJANA J MADHU',
      'designation': 'Agriculture Officer',
      'phone': '47522270367',
      'email': 'kbyerroor@gmail.com',
    },
    {
      'slNo': '74',
      'office': 'Agricultural Officer Krishi Bhavan Aryankavu Kollam',
      'chargeOfficer': 'AMPILY T',
      'designation': 'Agriculture Officer',
      'phone': '9383478912',
      'email': 'kbaryankavu@gamil.com',
    },
    {
      'slNo': '75',
      'office': 'Agricultural Officer Krishi Bhavan Kulathupuzha Kollam',
      'chargeOfficer': 'PRIYAKUMAR.P',
      'designation': 'Agriculture Officer',
      'phone': '6238800810',
      'email': 'id.kbkulathupuzha@gmail.com',
    },
    {
      'slNo': '76',
      'office': 'Agricultural Officer Krishi Bhavan Edamulackal Kollam',
      'chargeOfficer': 'Krishna S S',
      'designation': 'Agriculture Officer',
      'phone': '9383478956',
      'email': 'kbedamulakkal@gmail.com',
    },
    {
      'slNo': '77',
      'office': 'Agricultural Officer Krishi Bhavan Anchal Kollam',
      'chargeOfficer': 'jinisha Rani T',
      'designation': 'Agriculture Officer',
      'phone': '9383478962',
      'email': 'kbanchal5454@gmail.com',
    },
    {
      'slNo': '78',
      'office': 'Agricultural Officer Krishi Bhavan Karavaloor Kollam',
      'chargeOfficer': 'julie alex',
      'designation': 'Agriculture Officer',
      'phone': '9383478910',
      'email': 'kbkaravaloor@gmail.com',
    },
    {
      'slNo': '79',
      'office': 'Agricultural Officer Krishi Bhavan Alayamon Kollam',
      'chargeOfficer': 'SURESH',
      'designation': 'Agriculture Officer',
      'phone': '9383478954',
      'email': 'alayamokb@gmail.com',
    },
    {
      'slNo': '80',
      'office': 'Assistant Director of Agriculture (ADA) Ochira Kollam',
      'chargeOfficer': 'REENARAVEENDRAN',
      'designation': 'Assistant Director of Agriculture',
      'phone': '9383470220',
      'email': 'adaoachira.agri@kerala.gov.in',
    },
    {
      'slNo': '81',
      'office': 'Assistant Director of Agriculture (ADA) Chavara Kollam',
      'chargeOfficer': 'SHERIN MULLER',
      'designation': 'Assistant Director of Agriculture',
      'phone': '9383470343',
      'email': 'adachavara@gmail.com',
    },
    {
      'slNo': '82',
      'office': 'Assistant Director of Agriculture (ADA) Eravipuram Kollam',
      'chargeOfficer': 'L.PREETHA',
      'designation': 'Assistant Director of Agriculture',
      'phone': '4742504167',
      'email': 'adaepm@gmail.com',
    },
    {
      'slNo': '83',
      'office': 'Assistant Director of Agriculture (ADA) Anchalummoodu Kollam',
      'chargeOfficer': '',
      'designation': '',
      'phone': '',
      'email': '',
    },
    {
      'slNo': '84',
      'office':
          'Assistant Director of Agriculture (ADA) Chittumala Kundara Kollam',
      'chargeOfficer': 'RAJEE',
      'designation': 'Assistant Director of Agriculture',
      'phone': '9383470370',
      'email': 'adakundara.agri@kerala.gov.in',
    },
    {
      'slNo': '85',
      'office': 'Assistant Director of Agriculture (ADA) Sasthamkotta Kollam',
      'chargeOfficer': 'PUSHPA JOSEPH',
      'designation': 'Assistant Director of Agriculture',
      'phone': '9383470660',
      'email': 'adasasthamcotta@gmail.com',
    },
    {
      'slNo': '86',
      'office': 'Assistant Director of Agriculture (ADA) Kottarakkara Kollam',
      'chargeOfficer': 'Jayasree R',
      'designation': 'Assistant Director of Agriculture',
      'phone': '9383470353',
      'email': 'adaktr@gmail.com',
    },
    {
      'slNo': '87',
      'office': 'Assistant Director of Agriculture (ADA) Vettikkavala Kollam',
      'chargeOfficer': 'AJITHKUMAR P V',
      'designation': 'Assistant Director of Agriculture',
      'phone': '4742404292',
      'email': 'adavtkla@gmail.com',
    },
    {
      'slNo': '88',
      'office':
          'Assistant Director of Agriculture (ADA) Chadayamangalam Kollam',
      'chargeOfficer': 'V S RAJALEKSHMI',
      'designation': 'Assistant Director of Agriculture',
      'phone': '4742477138',
      'email': 'adacdlm@gmail.com',
    },
    {
      'slNo': '89',
      'office': 'Assistant Director of Agriculture (ADA) Anchal Kollam',
      'chargeOfficer': 'Sindhu',
      'designation': 'Assistant Director of Agriculture',
      'phone': '9383470355',
      'email': 'adaanchal@gmail.com',
    },
    {
      'slNo': '90',
      'office': 'Assistant Director of Agriculture (ADA) Pathanapuram Kollam',
      'chargeOfficer': 'RATHEESH',
      'designation': 'Assistant Director of Agriculture',
      'phone': '9383470250',
      'email': 'adapathanapuram.agri@kerala.gov.in',
    },
  ];

  List<Map<String, String>> filteredOfficers = [];
  final TextEditingController _searchController = TextEditingController();
  String _selectedDesignation = 'All';

  @override
  void initState() {
    super.initState();
    filteredOfficers = officers;
    _searchController.addListener(_filterOfficers);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterOfficers() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      filteredOfficers = officers.where((officer) {
        final matchesSearch =
            officer['office']!.toLowerCase().contains(query) ||
            officer['chargeOfficer']!.toLowerCase().contains(query) ||
            officer['designation']!.toLowerCase().contains(query);

        final matchesDesignation =
            _selectedDesignation == 'All' ||
            officer['designation']!.toLowerCase().contains(
              _selectedDesignation.toLowerCase(),
            );

        return matchesSearch && matchesDesignation;
      }).toList();
    });
  }

  Future<void> _makePhoneCall(String phoneNumber) async {
    if (phoneNumber.isEmpty) return;

    final Uri launchUri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    } else {
      throw 'Could not launch $launchUri';
    }
  }

  Future<void> _sendEmail(String email) async {
    if (email.isEmpty) return;

    final Uri launchUri = Uri(scheme: 'mailto', path: email);
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    } else {
      throw 'Could not launch $launchUri';
    }
  }

  @override
  Widget build(BuildContext context) {
    final designations = [
      'All',
      ...officers
          .map((e) => e['designation']!)
          .where((designation) => designation.isNotEmpty)
          .toSet()
          .toList(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Krishi Bhavan Officers - Kollam'),
        backgroundColor: Colors.green.shade700,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.green.shade50, Colors.green.shade100],
          ),
        ),
        child: Column(
          children: [
            // Search and Filter Section
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // Search Bar
                  TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Search by office name or officer...',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Designation Filter
                  SizedBox(
                    height: 50,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: designations.length,
                      itemBuilder: (context, index) {
                        final designation = designations[index];
                        return Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: FilterChip(
                            label: Text(designation),
                            selected: _selectedDesignation == designation,
                            onSelected: (selected) {
                              setState(() {
                                _selectedDesignation = selected
                                    ? designation
                                    : 'All';
                                _filterOfficers();
                              });
                            },
                            backgroundColor: Colors.white,
                            selectedColor: Colors.green.shade300,
                            labelStyle: TextStyle(
                              color: _selectedDesignation == designation
                                  ? Colors.white
                                  : Colors.green.shade700,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            // Results Count
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${filteredOfficers.length} officers found',
                    style: TextStyle(
                      color: Colors.green.shade700,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (_searchController.text.isNotEmpty ||
                      _selectedDesignation != 'All')
                    TextButton(
                      onPressed: () {
                        _searchController.clear();
                        setState(() {
                          _selectedDesignation = 'All';
                          filteredOfficers = officers;
                        });
                      },
                      child: const Text('Clear filters'),
                    ),
                ],
              ),
            ),
            // Officers List
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16.0),
                itemCount: filteredOfficers.length,
                itemBuilder: (context, index) {
                  final officer = filteredOfficers[index];
                  return Card(
                    elevation: 3,
                    margin: const EdgeInsets.only(bottom: 16.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Office and SL No
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  officer['office']!,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.green.shade100,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  'SL: ${officer['slNo']}',
                                  style: TextStyle(
                                    color: Colors.green.shade800,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),

                          // Charge Officer and Designation
                          Text(
                            'Officer: ${officer['chargeOfficer']!.isEmpty ? 'Not Available' : officer['chargeOfficer']!}',
                            style: TextStyle(color: Colors.grey.shade700),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Designation: ${officer['designation']!.isEmpty ? 'Not Available' : officer['designation']!}',
                            style: TextStyle(color: Colors.grey.shade700),
                          ),
                          const SizedBox(height: 12),

                          // Contact Information
                          if (officer['phone']!.isNotEmpty)
                            Row(
                              children: [
                                Icon(
                                  Icons.phone,
                                  size: 16,
                                  color: Colors.green.shade700,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  officer['phone']!,
                                  style: TextStyle(
                                    color: Colors.green.shade700,
                                  ),
                                ),
                                const Spacer(),
                                ElevatedButton(
                                  onPressed: () =>
                                      _makePhoneCall(officer['phone']!),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green.shade700,
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 8,
                                    ),
                                  ),
                                  child: const Text('Call'),
                                ),
                              ],
                            ),

                          if (officer['email']!.isNotEmpty)
                            Column(
                              children: [
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.email,
                                      size: 16,
                                      color: Colors.green.shade700,
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        officer['email']!,
                                        style: TextStyle(
                                          color: Colors.green.shade700,
                                        ),
                                      ),
                                    ),
                                    ElevatedButton(
                                      onPressed: () =>
                                          _sendEmail(officer['email']!),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.green.shade500,
                                        foregroundColor: Colors.white,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            20,
                                          ),
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 16,
                                          vertical: 8,
                                        ),
                                      ),
                                      child: const Text('Email'),
                                    ),
                                  ],
                                ),
                              ],
                            ),

                          if (officer['phone']!.isEmpty &&
                              officer['email']!.isEmpty)
                            Text(
                              'Contact information not available',
                              style: TextStyle(
                                color: Colors.grey.shade500,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
