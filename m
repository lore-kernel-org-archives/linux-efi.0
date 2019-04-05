Return-Path: <SRS0=oSEl=SH=vger.kernel.org=linux-efi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ECC2AC282CE
	for <linux-efi@archiver.kernel.org>; Fri,  5 Apr 2019 21:11:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B46D020651
	for <linux-efi@archiver.kernel.org>; Fri,  5 Apr 2019 21:11:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726223AbfDEVLq (ORCPT <rfc822;linux-efi@archiver.kernel.org>);
        Fri, 5 Apr 2019 17:11:46 -0400
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:58126 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726167AbfDEVLq (ORCPT
        <rfc822;linux-efi@vger.kernel.org>); Fri, 5 Apr 2019 17:11:46 -0400
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x35L8nYY083954
        for <linux-efi@vger.kernel.org>; Fri, 5 Apr 2019 17:11:45 -0400
Received: from e34.co.us.ibm.com (e34.co.us.ibm.com [32.97.110.152])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2rpendg3g0-1
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NOT)
        for <linux-efi@vger.kernel.org>; Fri, 05 Apr 2019 17:11:44 -0400
Received: from localhost
        by e34.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-efi@vger.kernel.org> from <cclaudio@linux.ibm.com>;
        Fri, 5 Apr 2019 22:11:44 +0100
Received: from b03cxnp08026.gho.boulder.ibm.com (9.17.130.18)
        by e34.co.us.ibm.com (192.168.1.134) with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted;
        (version=TLSv1/SSLv3 cipher=AES256-GCM-SHA384 bits=256/256)
        Fri, 5 Apr 2019 22:11:40 +0100
Received: from b03ledav004.gho.boulder.ibm.com (b03ledav004.gho.boulder.ibm.com [9.17.130.235])
        by b03cxnp08026.gho.boulder.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id x35LBd7q55312562
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 5 Apr 2019 21:11:39 GMT
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 3309A7805E;
        Fri,  5 Apr 2019 21:11:39 +0000 (GMT)
Received: from b03ledav004.gho.boulder.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id 270367805C;
        Fri,  5 Apr 2019 21:11:36 +0000 (GMT)
Received: from [9.85.129.145] (unknown [9.85.129.145])
        by b03ledav004.gho.boulder.ibm.com (Postfix) with ESMTP;
        Fri,  5 Apr 2019 21:11:35 +0000 (GMT)
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
From:   Claudio Carvalho <cclaudio@linux.ibm.com>
Date:   Fri, 5 Apr 2019 18:11:34 -0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.0
MIME-Version: 1.0
In-Reply-To: <CACdnJuu8OqMrSs0esOmf=ro9n00aYEQ-nikAh6v6sk+YAQw4cQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-TM-AS-GCONF: 00
x-cbid: 19040521-0016-0000-0000-0000099D0EF5
X-IBM-SpamModules-Scores: 
X-IBM-SpamModules-Versions: BY=3.00010875; HX=3.00000242; KW=3.00000007;
 PH=3.00000004; SC=3.00000284; SDB=6.01184848; UDB=6.00620420; IPR=6.00965590;
 MB=3.00026311; MTD=3.00000008; XFM=3.00000015; UTC=2019-04-05 21:11:43
X-IBM-AV-DETECTION: SAVI=unused REMOTE=unused XFE=unused
x-cbparentid: 19040521-0017-0000-0000-000042B5C1F8
Message-Id: <d79f47f8-9006-3a47-2bdc-58012cef5c7e@linux.ibm.com>
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-04-05_15:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1904050140
Sender: linux-efi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-efi.vger.kernel.org>
X-Mailing-List: linux-efi@vger.kernel.org
Message-ID: <20190405211134.2IIB2bIjRGHjpHf0x_a33vZHfbIbwaupZgi0y3kBFPA@z>


On 4/3/19 7:27 PM, Matthew Garrett wrote:
> On Tue, Apr 2, 2019 at 4:31 PM Claudio Carvalho <cclaudio@linux.ibm.com> wrote:
>>
>> On 4/2/19 6:51 PM, Matthew Garrett wrote:
>>> So you implement the full PK/KEK/db/dbx/dbt infrastructure, and
>>> updates are signed in the same way?
>> For the first version, our firmware will implement a simplistic PK, KEK and
>> db infrastructure (without dbx and dbt) where only the Setup and User modes
>> will be supported.
> Not supporting dbx seems like a pretty significant shortcoming. How
> are signatures meant to be revoked?


We began by focusing on certificates for keys that can be added at
runtime.  Before adding support for revocation, we plan to gather
additional use cases.  In the meantime, unwanted certificates can be
removed by the administrator.


>
>> PK, KEK and db updates will be signed the same way, that is, using
>> userspace tooling like efitools in PowerNV. As for the authentication
>> descriptors, only the EFI_VARIABLE_AUTHENTICATION_2 descriptor will be
>> supported.
> Is this API documented?


The API is still a work in progress.  We are planning to publish a document
describing the current API and overall design shortly.

Perhaps the biggest departure is that the secure variables are stored in
flash memory that is not lockable.  In order to protect the secure
variables, hashes of the flash regions where they're stored are written to
TPM NVRAM indices.  The TPM NVRAM indices we use are write locked at
runtime.  The sysadmin enqueues update commands in flash.  During the next
boot, the firmware verifies and processes the commands to update the
certificate store and accompanying integrity hashes in the TPM NVRAM
indices and write locks them.  Before certificates read from flash are
used, the certificate store is hashed and compared against the hashes
stored from the TPM.  The one exception is the PK. We store it in a TPM
NVRAM index by itself rather than flash because updates to it must be
guaranteed to be atomic.


>>> In that case we might be better off with a generic interface for this
>>> purpose that we can expose on all platforms that implement a secure
>>> boot key hierarchy. Having an efivarfs that doesn't allow the creation
>>> of arbitrary attributes may break other existing userland
>>> expectations.
>>>
>> For what it's worth, gsmi uses the efivars infrastructure for EFI-like
>> variables.
> My recollection is that at the time the Chromebook firmware still had
> EFI underpinnings and the gsmi code was largely just an alternate
> mechanism for calling into something that was fundamentally the EFI
> variable store. With hindsight I don't think layering this was the
> right move - we've adjusted the semantics of efivarfs on more than one
> occasion to deal with the behaviour of real-world EFI platforms, and I
> don't think it's helpful to end up in a situation where we're trying
> to keep behaviour consistent among entirely different firmware
> interfaces.
>
>> What might a generic interface look like?  It would have to work for
>> existing secure boot solutions - including EFI - which would seem to imply
>> changes to userspace tools.
> I think that depends on exactly what problem you're trying to solve.
> Some aspects of the EFI secure boot design end up mirroring the
> economics of the PC ecosystem rather than being inherently good design
> goals, so it'd be helpful to know whether you're taking this solution
> because you want the same three-level key infrastructure or because
> that just leaves you compatible with the tooling.


In our use case,  the three-level key hierarchy conveniently supports the
concept of (1) an administrator authority, who authorizes (2) other
organizations, e.g., distros, to provide (3) certificates for their code
signing keys.   By using efivars, we leverage pre-existing userspace EFI
tools to generate authenticated updates and certificates.  Additionally,
pre-existing kernel infrastructure simplifies efivars processing.  


Thanks,
Claudio

