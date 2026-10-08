Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98A2C25785D;
	Thu,  8 Oct 2026 16:02:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791475345; cv=none; b=WRwlQ/UQwjcyWiqmMxFw93/RjnWm7Ab0yoy6GbgvVZTD+Dl3AlWsYM+ODM/EiZVgNn5Dip+CjfOoXbIsZtrEytsNMY9g3Reb6+d6u+Vcqjh6q+Wq5DJH6OHmdTDbvYL0n0YpBBg4B+XLTemzV+9A6PjUtD/GTHerTodIhgARCIc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791475345; c=relaxed/simple;
	bh=TPwcV5nHsNXMVYbUSLug39J/MJoI252ecElbh606bFY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=nYaGZKtSIcrR3jNIzolkkF13xIapSKZYqNmhtGK+vs73EnIfNR1s9eUWFOpe43OVJYPSLecUyMtGmWVAefItX5cOjmX3ZbNaHCn0BOHuUqi7Qr2hG0skQ4q7FlIy12cmcaBEt8EjvsJ9qAXFwAMEdUggMR4tyIEb12HeIDCx7fA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=NUpEyT9f; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="NUpEyT9f"
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 698EZbZR1466473;
	Thu, 8 Oct 2026 15:58:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=MKzQ9B
	bCztFRJVboYEW2uapSEqo2bUDni7F/LZQBQOw=; b=NUpEyT9f6R8W5EngW2lah5
	PS4wIYrCjjyl1SxbdZImmFusTPIMj3keWakE1j62pzaHEYKIlejo248w4GIKAp4R
	IY73ZTxfdSxNcZNr/9fjCLWxomQefq4JcbIgxTyXMKpvNHKe1TBYRQrvrhxmHbO5
	7IT794i+IOvDlGJ8AhIyiLrK68AMrnOzTIbSSE0FAHKbINaZtFZZ7W/hpgWAdZP0
	e7bstH15Ji56I1a7yO0Hc4fL7L0Wr5xS+iRzA4sMbhY9HhxUus26hoUF32movBzl
	QEe8n1mEANwh9uA41GxfdRece+/uIQrECALG6UxHEOBsQ9v09bkTFhnrmegM4HYw
	==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4h5xjw4ha5-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 08 Oct 2026 15:58:37 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 698EXcu73632325;
	Thu, 8 Oct 2026 15:58:36 GMT
Received: from smtprelay03.dal12v.mail.ibm.com ([172.16.1.5])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 4h5a6dqu5k-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 08 Oct 2026 15:58:36 +0000 (GMT)
Received: from smtpav05.wdc07v.mail.ibm.com (smtpav05.wdc07v.mail.ibm.com [10.39.53.232])
	by smtprelay03.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 698FwZE119530376
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 8 Oct 2026 15:58:36 GMT
Received: from smtpav05.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id B362A58059;
	Thu,  8 Oct 2026 15:58:35 +0000 (GMT)
Received: from smtpav05.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 5C78758053;
	Thu,  8 Oct 2026 15:58:27 +0000 (GMT)
Received: from [9.224.94.162] (unknown [9.224.94.162])
	by smtpav05.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Thu,  8 Oct 2026 15:58:27 +0000 (GMT)
Message-ID: <2bc4cd4b-c01e-49e6-a0ac-d800489c7fd0@linux.ibm.com>
Date: Thu, 8 Oct 2026 17:58:23 +0200
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PROPOSAL] Replace gcov and kcov with llvm-cov
To: Chuck Wolber <chuck@wolber.net>, Masami Hiramatsu <mhiramat@kernel.org>
Cc: Marco Elver <elver@google.com>, kasan-dev@googlegroups.com,
        nathan@kernel.org, akpm@linux-foundation.org,
        anton.ivanov@cambridgegreys.com, ardb@kernel.org, arnd@arndb.de,
        bhelgaas@google.com, bp@alien8.de, dave.hansen@linux.intel.com,
        dvyukov@google.com, hpa@zytor.com, jinghao7@illinois.edu,
        johannes@sipsolutions.net, jpoimboe@kernel.org, justinstitt@google.com,
        kees@kernel.org, kent.overstreet@linux.dev, linux-arch@vger.kernel.org,
        linux-efi@vger.kernel.org, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
        linux-um@lists.infradead.org, llvm@lists.linux.dev, luto@kernel.org,
        marinov@illinois.edu, masahiroy@kernel.org, maskray@google.com,
        mathieu.desnoyers@efficios.com, mingo@redhat.com, morbo@google.com,
        Nick Desaulniers <ndesaulniers@google.com>,
        "Paul E. McKenney" <paulmck@kernel.org>, richard@nod.at,
        Steven Rostedt <rostedt@goodmis.org>, samitolvanen@google.com,
        tglx@linutronix.de, tingxur@illinois.edu, tyxu@illinois.edu,
        wentaoz5@illinois.edu, x86@kernel.org, peterz@infradead.org,
        Sasha Levin <sashal@kernel.org>, Aleksandr Nogikh <nogikh@google.com>,
        Taras Madan <tarasmadan@google.com>,
        Alexander Potapenko <glider@google.com>
References: <00ed0b57-ad05-4c5d-b152-7c81df94b23a@app.fastmail.comCANpmjNOaykC4McAj=gZghqPSQc9aGBP_CjgKmp3n2yjeJTxDSA@mail.gmail.com<41913a77-5c57-4967-8166-765dd5dde1bf@app.fastmail.com>
 <20261007023045.04BD71F0089B@smtp.kernel.org>
 <c84149c4-26c3-476e-93d5-4fe72f7c708b@app.fastmail.com>
From: Peter Oberparleiter <oberpar@linux.ibm.com>
Content-Language: en-US
In-Reply-To: <c84149c4-26c3-476e-93d5-4fe72f7c708b@app.fastmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDA4MDA2MiBTYWx0ZWRfX7agpraaix6LX
 pxbSLInm1SOVSMqFZkeCzSG4ELn15XWuuiSkFTx8GEFcjXzJj1IS9PoZUBgM9gmbKDN9USkrNpg
 VvibfOKL5A/FGyayGS8iv9dPws+IyRs=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDA4MDA2MiBTYWx0ZWRfX5TPgyb0TaclZ
 R1ioCVJIT2E7H9BI0W8k9DMtame5wKM6sdUKaBff5OOvTVAlsxyMSBs0KyoplsAoV1hQqTuHtOm
 TG6z7uA70zppo5eFEPOIbLR2/H1v1dJU/qH/ISHoCGC4OOgRP8JT4zv5lMChBoXdLPlFENU1nxs
 PspsvpWcbVHSDHvTQvAHT5jk7ZHhl0Wq3r0/dwuAFkMaG4rhJ+FX4oVHg4Bbk9pXqHidRKkH/sb
 2FoEaWuFCGTIWv6OSa9wJC+liprCEPIGTGmKpfEI/m/2cRleJ7Al0ZnDo+yI9bvm62he9iCcN3s
 85+4XysbhNz/Bz+bg60B7FoNf4ZCxiJVfU+pzn25TNvRczR0feceOwt2LVGG1Rz5hn0EpIf5d+y
 fw1+5Pdet7/5OyO/zsWt8jP9qApMOiFBOdukWZlyp8qp3i83MwZgMXTwLSHM62AIVNGNX1yrtCx
 YF5gYAHdASABkErmkqw==
X-Proofpoint-GUID: D0LHLpfRzzJt1ukAVZrjSxamRXnmTCJi
X-Proofpoint-ORIG-GUID: VhFqLZb7k16-ym5GsOt8QtLcp8xXQpfS
X-Authority-Analysis: v=2.4 cv=XcwcX455 c=1 sm=1 tr=0 ts=6ac7bdae cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=Y2IxJ9c9Rs8Kov3niI8_:22 a=VwQbUJbxAAAA:8
 a=LyIsrzihAAAA:8 a=tWOiO5aNUmIPvu4ykj4A:9 a=QEXdDO2ut3YA:10
 a=PBbf0nNFGpdpuOWig3Fv:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-08_05,2026-10-08_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1011 lowpriorityscore=0 priorityscore=1501 phishscore=0
 malwarescore=0 bulkscore=0 adultscore=0 spamscore=0 suspectscore=0
 impostorscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2610020000
 definitions=main-2610080062

On 07.10.2026 06:17, Chuck Wolber wrote:
> On Wed, Oct 7, 2026, at 2:30 AM, Masami Hiramatsu wrote:
>> On Tue, 06 Oct 2026 16:27:11 +0000, Chuck Wolber <chuck@wolber.net> wrote:
>>> On Tue, Oct 6, 2026, at 4:10 PM, Marco Elver wrote:
>>>> On Tue, 6 Oct 2026 at 17:14, Chuck Wolber <chuck@wolber.net> wrote:
>>
>>>>> If there is a desire to take this in pieces or implement other
>>>>> intermediate steps, let me know. Otherwise I can generate a
>>>>> monolithic set all at once.
>>>>>
>>>>> [1] https://lore.kernel.org/lkml/20240905043245.1389509-1-wentaoz5@illinois.edu/
>>>>>
>>>>>>> llvm-cov is generally useful to have; llvm-cov is closest to
>>>>>>> gcov, so that might make sense to replace.
>>>
>>> Swapping llvm-cov for gcov to start with is pretty straightforward,
>>> so I can aim my initial patch set there.
>>
>> Hmm, is it necessary to remove gcov? Would it be difficult to simply
>> add support for llvm-cov and enable (make kconfig selectable) one or
>> the other depending on the compiler?
> 
> Not strictly necessary, no. And what you are describing is what our
> original patches do.
> 
> The concern was why we would want to have three separate code coverage
> tools in the kernel. Each has their own way of doing things, and they
> can all live together in the kernel harmoniously.
> 
> But the concern was raised so I am trying to find a way forward.
> 
> The llvm-cov approach gives results that are reliably tied to actual
> lines of source, so that is the one I reflexively reach for any time I
> need code coverage. I am at a loss (but definitely willing to be
> educated) as to what value gcov style coverage provides in comparison.

I agree that llvm-cov native kernel support has some advantages over
current gcov-kernel support:

* MC/DC coverage (though a series introducing MC/DC for gcov-kernel
  exists, pending review..)
* Sub-line precision data
* Optimization doesn't affect precision of coverage data

The lack of support for non-x86 architectures would be an initial
obstacle for some users, but one that can be addressed.

The main problem I see with the idea of replacing gcov-kernel with
llvm-cov is that it would immediately disrupt a lot of gcov-kernel based
workflows that people have developed over time, e.g. automated coverage
measurements as part of CI tests, maybe coupled with specialized tooling
features like lcov's differential coverage analysis. I'm not sure that
the extra value provided by llvm-cov today justifies the effort needed
to move away from gcov-kernel for everyone.

Also not everyone may be able to switch from GCC to LLVM for compiling
instrumented kernels, e.g. because their test kernels need to match the
associated kernel-based product (think Linux distributions). Those users
would then be left with no workable coverage measurement option at all.

> I also found some interesting possibilities using intrinsics to enable
> boot time tracing with llvm-cov. That is, of course, experimental and
> not something I am considering for the intial patch-set. But it got me
> thinking about broader configurability that supports more granular forms
> of coverage that _may_ address kcov needs in the long term.
> 
> I have been working on this off-and on for a few years and still really
> want to see this idea succeed. Any guidance on a workable path forward
> would be greatly appreciated.

My recommendation would be to keep working towards getting llvm-cov
integrated as an alternative to gcov-kernel for LLVM users. This would
enable kernel developers that are not bound to using GCC to benefit from
the current (and potential future) unique benefits of llvm-cov data.

As for whether the kernel needs two coverage mechanisms (not counting
KCOV - see Marco Elver's previous email): coverage and instrumentation
are inherently toolchain-specific today. Since the kernel supports both
GCC and LLVM, supporting the corresponding toolchain-specific coverage
mechanisms seems reasonable to me.

> Another option, proposed by Sasha Levin[1], was to use a single
> /sys/kernel/debug/coverage interface, quoting him here:
> 
> "To clarify, are you suggesting that we'll have something like a single
>  /sys/kernel/debug/coverage interface that is producing the same structured
>  output whether we use gcov or llvm?"
> 
> I am not sure it is feasible to use the same structured ouput, but it
> would isolate things down to a single interface with KConfig knobs being
> used to select which coverage data one can expect to find there.

The data format produced by instrumented kernel code is defined by the
associated toolchain. I don't see a feasible way to merge/map these. One
could argue though that the code for both mechanisms could be better
co-located, both in kernel source tree and configuration menus. Also
there might be some value in merging the per-directory/per-file
no-profile indicators (GCOV_PROFILE/LLVM_COV_PROFILE).


-- 
Peter Oberparleiter
Linux on IBM Z Development - IBM Germany R&D
