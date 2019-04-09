Return-Path: <SRS0=iuKK=SL=vger.kernel.org=linux-efi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39CA0C282CE
	for <linux-efi@archiver.kernel.org>; Tue,  9 Apr 2019 22:55:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0287220830
	for <linux-efi@archiver.kernel.org>; Tue,  9 Apr 2019 22:55:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726766AbfDIWzu (ORCPT <rfc822;linux-efi@archiver.kernel.org>);
        Tue, 9 Apr 2019 18:55:50 -0400
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:37850 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726723AbfDIWzu (ORCPT
        <rfc822;linux-efi@vger.kernel.org>); Tue, 9 Apr 2019 18:55:50 -0400
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x39MsRtk045175
        for <linux-efi@vger.kernel.org>; Tue, 9 Apr 2019 18:55:49 -0400
Received: from e13.ny.us.ibm.com (e13.ny.us.ibm.com [129.33.205.203])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2rs173fq2d-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-efi@vger.kernel.org>; Tue, 09 Apr 2019 18:55:48 -0400
Received: from localhost
        by e13.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-efi@vger.kernel.org> from <cclaudio@linux.ibm.com>;
        Tue, 9 Apr 2019 23:55:47 +0100
Received: from b01cxnp22035.gho.pok.ibm.com (9.57.198.25)
        by e13.ny.us.ibm.com (146.89.104.200) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Tue, 9 Apr 2019 23:55:44 +0100
Received: from b01ledav005.gho.pok.ibm.com (b01ledav005.gho.pok.ibm.com [9.57.199.110])
        by b01cxnp22035.gho.pok.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x39Mthsp29360202
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 9 Apr 2019 22:55:43 GMT
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3D72EAE05F;
        Tue,  9 Apr 2019 22:55:43 +0000 (GMT)
Received: from b01ledav005.gho.pok.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3D65FAE05C;
        Tue,  9 Apr 2019 22:55:41 +0000 (GMT)
Received: from [9.80.221.121] (unknown [9.80.221.121])
        by b01ledav005.gho.pok.ibm.com (Postfix) with ESMTP;
        Tue,  9 Apr 2019 22:55:41 +0000 (GMT)
Subject: Re: [PATCH 0/4] Enabling secure boot on PowerNV systems
To:     Matthew Garrett <mjg59@google.com>
Cc:     linuxppc-dev@ozlabs.org, linux-efi <linux-efi@vger.kernel.org>,
        linux-integrity <linux-integrity@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Paul Mackerras <paulus@samba.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Jeremy Kerr <jk@ozlabs.org>,
        Matthew Garret <matthew.garret@nebula.com>,
        Nayna Jain <nayna@linux.ibm.com>
References: <20190402181505.25037-1-cclaudio@linux.ibm.com>
 <CACdnJuumhkqTb4+1=QBiLmbW4xd3wW=MZu6Tj_KdaoTMhCN+Tg@mail.gmail.com>
 <4ce5e057-0702-b0d5-7bb2-cea5b22e2efa@linux.ibm.com>
 <CACdnJusBm93zwDqTXTx_QYsg1-aGUAAHm_qq8Lcx3TvGTxdmbg@mail.gmail.com>
 <2208f156-d441-3082-2f4c-8030c84ef788@linux.ibm.com>
 <CACdnJuu8OqMrSs0esOmf=ro9n00aYEQ-nikAh6v6sk+YAQw4cQ@mail.gmail.com>
 <d79f47f8-9006-3a47-2bdc-58012cef5c7e@linux.ibm.com>
 <CACdnJuv_5A1_6CH1+Jn7SCrmW8Y6JuzsMmJoc1=_vn0nKdYMjQ@mail.gmail.com>
From:   Claudio Carvalho <cclaudio@linux.ibm.com>
Date:   Tue, 9 Apr 2019 19:55:40 -0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.0
MIME-Version: 1.0
In-Reply-To: <CACdnJuv_5A1_6CH1+Jn7SCrmW8Y6JuzsMmJoc1=_vn0nKdYMjQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-TM-AS-GCONF: 00
x-cbid: 19040922-0064-0000-0000-000003C8AB6D
X-IBM-SpamModules-Scores: 
X-IBM-SpamModules-Versions: BY=3.00010898; HX=3.00000242; KW=3.00000007;
 PH=3.00000004; SC=3.00000284; SDB=6.01186785; UDB=6.00621592; IPR=6.00967545;
 MB=3.00026369; MTD=3.00000008; XFM=3.00000015; UTC=2019-04-09 22:55:47
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19040922-0065-0000-0000-00003D018DD4
Message-Id: <28bfc0a7-9ae5-2c99-e472-ea53f856bafc@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-04-09_12:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1904090144
Sender: linux-efi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-efi.vger.kernel.org>
X-Mailing-List: linux-efi@vger.kernel.org
Message-ID: <20190409225540.UhAT71kUFvIoYiN_H73MqcMd_Mdgtb-lbAb9zIb3CS0@z>


On 4/5/19 7:19 PM, Matthew Garrett wrote:
> On Fri, Apr 5, 2019 at 2:11 PM Claudio Carvalho <cclaudio@linux.ibm.com> wrote:
>>
>> On 4/3/19 7:27 PM, Matthew Garrett wrote:
>>> Not supporting dbx seems like a pretty significant shortcoming. How
>>> are signatures meant to be revoked?
>>
>> We began by focusing on certificates for keys that can be added at
>> runtime.  Before adding support for revocation, we plan to gather
>> additional use cases.  In the meantime, unwanted certificates can be
>> removed by the administrator.
> Based on our experience doing this in UEFI, that's insufficient - you
> want to be able to block individual binaries or leaf certificates
> without dropping trust in an intermediate certificate entirely.


We agree that a dbx would be useful for blacklisting particular kernels
signed with given certificate. However, we have been avoiding doing so for
the initial release of secure boot on OpenPOWER. We don't have individual
firmware binaries in OpenPOWER. Kernels are currently the only concern for
the OS secure boot certificates we're discussing here. Also, we have a very
limited keystore space in POWER9.

Petitboot doesn't have standardized OS kernel verification at all right
now.  Having the capability even without dbx seems valuable.


>
>>>> PK, KEK and db updates will be signed the same way, that is, using
>>>> userspace tooling like efitools in PowerNV. As for the authentication
>>>> descriptors, only the EFI_VARIABLE_AUTHENTICATION_2 descriptor will be
>>>> supported.
>>> Is this API documented?
>>
>> The API is still a work in progress.  We are planning to publish a document
>> describing the current API and overall design shortly.
> Ok. How are the attributes interpreted by the API?


We support a subset of standard EFI variable attributes, and we only use
EFI variables that relate to secure boot. Our goal is not to implement
UEFI.  However, we do seek to be compatible with user space tooling and
reuse as much existing infrastructure as possible. We don’t support the
following: EFI_VARIABLE_HARDWARE_ERROR_RECORD,
EFI_VARIABLE_AUTHENTICATED_WRITE_ACCESS and
EFI_VARIABLE_ENHANCED_AUTHENTICATED_ACCESS.


>
>> Perhaps the biggest departure is that the secure variables are stored in
>> flash memory that is not lockable.  In order to protect the secure
>> variables, hashes of the flash regions where they're stored are written to
>> TPM NVRAM indices.  The TPM NVRAM indices we use are write locked at
>> runtime.  The sysadmin enqueues update commands in flash.  During the next
>> boot, the firmware verifies and processes the commands to update the
>> certificate store and accompanying integrity hashes in the TPM NVRAM
>> indices and write locks them.  Before certificates read from flash are
>> used, the certificate store is hashed and compared against the hashes
>> stored from the TPM.  The one exception is the PK. We store it in a TPM
>> NVRAM index by itself rather than flash because updates to it must be
>> guaranteed to be atomic.
> What's the behaviour if multiple updates are enqueued? Does reading
> back show a mocked up updated variable or the original state?


Our secure variable updates are only applied at boot time. If any one of
them fails, they all fail.


>
>>> I think that depends on exactly what problem you're trying to solve.
>>> Some aspects of the EFI secure boot design end up mirroring the
>>> economics of the PC ecosystem rather than being inherently good design
>>> goals, so it'd be helpful to know whether you're taking this solution
>>> because you want the same three-level key infrastructure or because
>>> that just leaves you compatible with the tooling.
>>
>> In our use case,  the three-level key hierarchy conveniently supports the
>> concept of (1) an administrator authority, who authorizes (2) other
>> organizations, e.g., distros, to provide (3) certificates for their code
>> signing keys.   By using efivars, we leverage pre-existing userspace EFI
>> tools to generate authenticated updates and certificates.  Additionally,
>> pre-existing kernel infrastructure simplifies efivars processing.
> I'm not really clear on the workflow here. Who's the administrator
> authority? When would they be updating the second level of keys? If
> there's no support for revocation, why would distributions need two
> levels of key in the system database rather than just distributing a
> single intermediate and signing their actual signing certs with that?


In OpenPOWER systems, we enable our customers and business partners to
establish and manage the platform key certificate, which is the root of our
key hierarchy. From there, through the KEK, they can delegate authority to
intermediate level organizations, e.g. distros or IT departments or
business operations. Those intermediate level organizations then manage the
code signing certificates in the DB. If this answer doesn’t address your
question, can you please rephrase?


Thanks,
Claudio

