Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5D19408006;
	Tue, 19 May 2026 15:24:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779204292; cv=none; b=pqjLMDpJ5FmZyzbfTWRS/BJlqe5+e7ASu94RbLQr8EqRzk2wPVZGs0GK0OrQAFngTcEvqRy5IN624U/xA7W4o+llsd7tVf860hFywqDqscGSh8mGJ9PO2AgY4TrmQcSlQ9NXD7NXj6hoZZUX+KVgrr5qslaWq2Rm+XhM0ogJzRU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779204292; c=relaxed/simple;
	bh=YnvezWKZHJHKS2rlvWwaBf9roZI+rdXbINTjbGmL624=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=nUp2zIh6XTbnGkiaxzpCovKnoi5smGyB/r9zxlvizm4OzJfad0Rp4JUhp5GqfU+Zg+3ZXGw6Vx3o1pfg28ofAobyl2J6lohe6BBHv8HXySyXQAIFi7XRA47jZjmiW2k9JwE+LMMSGZvtoxurzY0blX7roCySs7c2Mz7EZXxW/kQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Bafaitpp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Bafaitpp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E062C2BCC6;
	Tue, 19 May 2026 15:24:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779204292;
	bh=YnvezWKZHJHKS2rlvWwaBf9roZI+rdXbINTjbGmL624=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject:From;
	b=Bafaitppo61aMU9XTXBjibM7oYBdi+30S8e+3898gDTzrm8upxuSKbcA7zfGSK5fl
	 2lZ5mUVRRyf7u0B1x+23nBoUce15MxjVMSq4fhKqGx4mZi7Qz0bv7HWT0Ju01tzudd
	 NEQ2rxfRTGsv72KNaSma6fKoIpyT3xpgHfFrV60cTPdiJ4iH2YhFcvtA2bUy5KYz6A
	 J/oVKe1vQ852LspNIqL5I4Oqbzh1xzSWhIS0VyRddkt/097wPEeAMSWTfEOna08xCU
	 iqPMDo1fksau3hm4bSRrEvWmyhHpNP0QPM/tYpQg0UQYRd8fGuAzmfMka41ei4Bh0o
	 m3nLBaGnZR7pQ==
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfauth.phl.internal (Postfix) with ESMTP id 8413AF4007C;
	Tue, 19 May 2026 11:24:51 -0400 (EDT)
Received: from phl-imap-05 ([10.202.2.95])
  by phl-compute-01.internal (MEProxy); Tue, 19 May 2026 11:24:51 -0400
X-ME-Sender: <xms:w4AMapeBAZJE9xSNN0_ikLhMKJis6GoeVaB8tYu_oZ0pdtVzMrizkg>
    <xme:w4AMaiCr1Ml_5y4wnkZ8pnI8pRBg9AF3irBEI5BfpRFZcCY9y0eCMaQ7TUrF-xx_E
    OqmAJi6D8vP7sLZlaj_ilZt19GGtUWwL7eTf4qC-7CKgsC4_skzkw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefhedrtddtgddugedvuddtucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepofggfffhvfevkfgjfhfutgfgsehtqhertdertdejnecuhfhrohhmpedftehrugcu
    uehivghshhgvuhhvvghlfdcuoegrrhgusgeskhgvrhhnvghlrdhorhhgqeenucggtffrrg
    htthgvrhhnpeeuteeiudeigeekjedvheduieehteetgfdtuefghfejgffhfedtleehvdeh
    fffhvdenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpe
    grrhguodhmvghsmhhtphgruhhthhhpvghrshhonhgrlhhithihqdduieejtdehtddtjeel
    qdeffedvudeigeduhedqrghruggspeepkhgvrhhnvghlrdhorhhgseifohhrkhhofhgrrh
    gurdgtohhmpdhnsggprhgtphhtthhopeehpdhmohguvgepshhmthhpohhuthdprhgtphht
    thhopegrrhgusgdoghhithesghhoohhglhgvrdgtohhmpdhrtghpthhtoheprhgrfhgrvg
    hlrdhjrdifhihsohgtkhhisehinhhtvghlrdgtohhmpdhrtghpthhtoheprhgrfhgrvghl
    sehkvghrnhgvlhdrohhrghdprhgtphhtthhopehlihhnuhigqdgrtghpihesvhhgvghrrd
    hkvghrnhgvlhdrohhrghdprhgtphhtthhopehlihhnuhigqdgvfhhisehvghgvrhdrkhgv
    rhhnvghlrdhorhhg
X-ME-Proxy: <xmx:w4AMavqUOj4SO2B9H6Jb4JcEaH92x4XDWLuQyOtUkdnRQhlYw65XUw>
    <xmx:w4AMailkPkcf9vCiarLZADkZAGo64SpgjyrqK64N4A0sHjjbnBJVEw>
    <xmx:w4AManzDkp2VrdO0gSF6WktGUU9Sn9OYujo3omRtzJaAVhT7J90y2g>
    <xmx:w4AMai_l36gPLI8hAmI_42I9ahKKSFb8qMDrvKyo_-TDorMqTGXSpQ>
    <xmx:w4AMarIpVGFo9dp-QephAgUMyobyyyq9X1_1xj78L2GqoyyfICjrLgBC>
Feedback-ID: ice86485a:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id 69C67182007A; Tue, 19 May 2026 11:24:51 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Tue, 19 May 2026 17:24:31 +0200
From: "Ard Biesheuvel" <ardb@kernel.org>
To: "Rafael J . Wysocki" <rafael@kernel.org>,
 "Ard Biesheuvel" <ardb+git@google.com>
Cc: linux-efi@vger.kernel.org, "Linux ACPI" <linux-acpi@vger.kernel.org>,
 "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Message-Id: <8a5e09e2-7df3-4c5f-92be-309628dfdba7@app.fastmail.com>
In-Reply-To: 
 <CAJZ5v0h5NvLK3Fs9Fw+GoKCs82SXP1_oRggiG_aH3wiuMkdnJA@mail.gmail.com>
References: <20260519082316.1959158-2-ardb+git@google.com>
 <CAJZ5v0h5NvLK3Fs9Fw+GoKCs82SXP1_oRggiG_aH3wiuMkdnJA@mail.gmail.com>
Subject: Re: [PATCH] efi: Allocate runtime workqueue before ACPI init
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable



On Tue, 19 May 2026, at 16:12, Rafael J. Wysocki wrote:
> On Tue, May 19, 2026 at 10:23=E2=80=AFAM Ard Biesheuvel <ardb+git@goog=
le.com> wrote:
>>
>> From: Ard Biesheuvel <ardb@kernel.org>
>>
>> Since commit
>>
>>   5894cf571e14 ("acpi/prmt: Use EFI runtime sandbox to invoke PRM han=
dlers")
>>
>> ACPI PRM calls are delegated to a workqueue which runs in a kernel
>> thread, making it easier to detect and mitigate faulting memory acces=
ses
>> performed by the firmware.
>>
>> Rafael reports that such PRM accesses may occur before efisubsys_init=
()
>> executes, which is where the workqueue is allocated, leading to NULL
>> pointer dereferences. Since acpi_init() [which triggers the early PRM
>> accesses] executes as a subsys_initcall() as well, and has its own
>> dependencies that may be sensitive to initcall ordering, deferring
>> acpi_init() is not an option.
>>
>> So instead, split off the workqueue allocation into its own postcore
>> initcall, as this is the only missing piece to allow EFI runtime calls
>> to be made. This ensures that EFI runtime call (including PRM calls) =
are
>> accessible to all code running at subsys_initcall() level.
>>
>> Fixes: 5894cf571e14 ("acpi/prmt: Use EFI runtime sandbox to invoke PR=
M handlers")
>> Reported-by: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
>> Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
>
> This should work AFAICS, so
>
> Reviewed-by: Rafael J. Wysocki (Intel) <rafael@kernel.org>
>

OK, I'll queue this up.
