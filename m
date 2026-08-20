Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8400842C4E6
	for <linux-efi@vger.kernel.org>; Thu, 20 Aug 2026 11:49:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787226597; cv=none; b=UFcAwo8pz67tEfFgjiwnI5+WDIw+QjZsUIKPJM3aBGdTstjNtnGQZO3yuz0aIxm011jrftFRPj3XtHF5faxj1AugUxtSjyGiSIeSp2UEuQYvrzQ622F8QQa4+0Tia+u/vWNDnJVb5mPO/40OgwcD7yU0/h8wTYlRAS/x/CszTQc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787226597; c=relaxed/simple;
	bh=FXjFw1aRdhlI3HJKqQHmH9CVzMHJZtaDCNKVDmNfgpU=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=mg85qGuC47Ze7Sb9m7Pq2s4UilP6L9a+OkHxjMij3iJpVI+aiwaT44KHGNVwqyxtqT8WsBbhD57tCunxOH9h6N8XqsQ+5G4/hCAL49BgLLS7tQE6MwSfcLFIeI0rNMUTDgGNEpqLGT2KJEP46Y/LDd1W9Z/2AbBDGJkvU5U9mH4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=T0LWmFsb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="T0LWmFsb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3C791F000E9;
	Thu, 20 Aug 2026 11:49:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787226596;
	bh=oCSHTk6Vsbud/jueL72abX4npLKH+zeCjs+1JynVlxw=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject;
	b=T0LWmFsbSRdM0k26BDUjqEgHUmH2D4Rgq6AyogSCaPqNbgtXde7vQXcxZhgyHFErC
	 OqiENtD+tVSLf6jhZAZNW9DuQn1RzUrJsp3EQxQVWJDnhbPZw2xFJ5QTZh2MvOOHe/
	 achDb4+ohr5JnAntWhd6kI2MmR6/3h4SaIZWXt6StenyFfF7VGO2mVsEuU4AH7tBk4
	 wUYT5pwLyyUSyJ8Do229ztXR4kruOj/CP55tLWY+y8Zs9mYtnkgLfbIyMB2CWSj47g
	 m8oHyoPfle+jmY/KASUtMym7uXwjN1tMIcV7jl/JmIroEGKenu7TjoOLu+Dr16f/FN
	 K85d0r4mBOGBw==
Received: from ams-compute-02.internal (ams-compute-02.internal [10.64.2.62])
	by mailfauth.ams.internal (Postfix) with ESMTP id 38BA01980060;
	Thu, 20 Aug 2026 07:49:54 -0400 (EDT)
Received: from ams-imap-11 ([10.64.2.31])
  by ams-compute-02.internal (MEProxy); Thu, 20 Aug 2026 07:49:54 -0400
X-ME-Sender: <xms:4OmGas2GMOgfnkr9X60ukDM5N4kmfidX29N6NOrFOVTKwkKsiucGQA>
    <xme:4OmGah5nUFwR3oXqQTUp0aVaBSayqBYvi0vdVRU1BteVVGsuhEW_QeB4YXCsMgSlW
    MyzkN8-DxmWaB-2NNO0rlu8qNqub1U3Ne58Dr_MaD6F7PYUU8_vvAU>
X-ME-Proxy-Cause: dmFkZTErGxiZH4DToEZ8yEt2lqI/2xdiVHFGjifXFSp0g6M1aGCl0MKBj2Hk9md9b04jPt
    v2GLPzSVbPpHYbWYM25VoPzQ3caxIoLw2Cbq4M4pQtyhci0K/O7FmroW1kO2QBajnXuzoc
    kb0q460EQqXOUY/1fIoYkplMU8JsHHyc3iWo5U/WXkN7ssTTytGrGXD9fW4TSfjOETorQZ
    ByujXJaREYPqKZhlUNuac6Vhh8cO8efds0Vyv+zvTu1gHTlX32E83SEPgQhxMU8o80WZbT
    Ny20LV5FbIkKvsU0qTAspSwmNFTO8Mq0q6bGspd9L3IWLcnd7lxyA8jit1jBI49Y7FRrQB
    jguGpsThJCkQlHiGWIjsmF3TzkyOnU2daKjS2aOiOtwT4vrLzbK1ZwfTeIty3n4NG88puG
    boUqiHcn+ZcBqPimC7UAxwQevoBqNbBRZqUT0504sI0TWbks48wk5yZkoXaxPuuKlGoCvW
    QL4UBsyzl/d9tmJXRumTjVdVQV4syLOAm759+ruUAjOqyxO54r6bLGHbNnR0jmmGuBWame
    uJaY5mmujS/wXM2/tAnrLMC+PSQuVi8FXmGiY0biYGeoyUWB+xJwclCzgR6raYdRgyZuFw
    YNgMhhnk53RFY0btoTF2Aeac6NaP3Jfzi6Ep2nvPGyRqBz4vbR9z70NbsckQ
X-ME-Proxy: <xmx:4umGauegS_hSA3j-LNUKCRyAj4C1CeQSI7d3K0in0kUcqFREldMlJA>
    <xmx:4umGaiRsBKRdolaqbQ4JEth2pxi63h-i4sv7NyjVSaxmsKHbObtq3Q>
    <xmx:4umGava-FCwJ75tO9s--3p1EAWxjo0_6X2rMXpasHTbzT6wzcPwNNA>
    <xmx:4umGatdNl1UfsFc8eFr2_9tfIIAEQLmNLJ9mmiK2tA7zqPoipWcSfw>
    <xmx:4umGaoIMHCnzYql_SPqz-o0wNO3GqsQf79RIJDZJAX9y2Dqa-RCaJC7z>
Feedback-ID: ice86485a:Fastmail
Received: by mailuser.ams.internal (Postfix, from userid 501)
	id 0CA7DF80070; Thu, 20 Aug 2026 07:49:52 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Thu, 20 Aug 2026 14:49:31 +0300
From: "Ard Biesheuvel" <ardb@kernel.org>
To: "Theodore Tucker" <theodore@tti0.net>, linux-kernel@vger.kernel.org
Cc: linux-efi@vger.kernel.org, "Guilherme G. Piccoli" <gpiccoli@igalia.com>,
 "Tony Luck" <tony.luck@intel.com>, "Kees Cook" <kees@kernel.org>,
 "Ilias Apalodimas" <ilias.apalodimas@linaro.org>
Message-Id: <55870f62-ee17-4aed-850e-790517f68eee@app.fastmail.com>
In-Reply-To: <6ecd6385-37c6-4ae8-8413-53a6e8602635@app.fastmail.com>
References: <20260625171214.8058-1-theodore@tti0.net>
 <6ecd6385-37c6-4ae8-8413-53a6e8602635@app.fastmail.com>
Subject: Re: [PATCH] efi: Make EFI_VARS_PSTORE depend on EFIVAR_FS
Content-Type: text/plain
Content-Transfer-Encoding: 7bit



On Thu, 23 Jul 2026, at 09:39, Ard Biesheuvel wrote:
> On Thu, 25 Jun 2026, at 19:12, Theodore Tucker wrote:
>> The efivars backend to pstore will not register if the efivarfs is
>> not available. The efivars sysfs interface was removed in Linux 6.0,
>> meaning efivarfs is now the only way pstore can write into EFI
>> variables. Making the dependency on the efivarfs explicit removes
>> a stumbling block when configuring a kernel with pstore.
>>
>> Signed-off-by: Theodore Tucker <theodore@tti0.net>
>> ---
>>  drivers/firmware/efi/Kconfig | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>
> Applied, thanks.
>

Actually, EFI pstore does not depend on efivarfs, it only depends on
the efivars layer.

Why do you think it needs to depend on EFIVAR_FS?

>> diff --git a/drivers/firmware/efi/Kconfig b/drivers/firmware/efi/Kconfig
>> index 29e0729299f5..8dfd21e7a8e4 100644
>> --- a/drivers/firmware/efi/Kconfig
>> +++ b/drivers/firmware/efi/Kconfig
>> @@ -9,7 +9,7 @@ config EFI_ESRT
>> 
>>  config EFI_VARS_PSTORE
>>  	tristate "Register efivars backend for pstore"
>> -	depends on PSTORE
>> +	depends on PSTORE && EFIVAR_FS
>>  	select UCS2_STRING
>>  	default y
>>  	help
>> -- 
>> 2.47.3
