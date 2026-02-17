Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B50D2FF148;
	Tue, 17 Feb 2026 10:27:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771324033; cv=none; b=ruif2kGDiB6Lb5H2IJQffLj1t5TP4BaB70xXj00NfyeeP/aj7nzqY/QkU5QS+JL73kFtLgMDTxdDgKz7bwrmh3AP140TP5dV1fOKebncJ4WUAHJXhovzgfRLTFEAPlzzxDy2arddBK/TLcRvDL/1HgNNKnRKvveuDC0q29fNUdI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771324033; c=relaxed/simple;
	bh=A1RZeYH6sHmVQh3ml2jbUXSijJJc+yhNtIXFCMMdagk=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=OQVGhYf03/FjDX84f3NIi4HHrwQd8rdS8tkh7asO7U92efQgFFxoZJLOv3OC19WjYe/J7gJkI5F1UQ7hVC05jECYtm2ifZNf/NDjjlU3dqIerB0IKnJkpgxx22T2oQJZ8xPFDZBOExE8+RM/UMWkWmrhfhiivEbDB+hXPttE4Vk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kGTZyWK9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kGTZyWK9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CD4BC19423;
	Tue, 17 Feb 2026 10:27:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771324032;
	bh=A1RZeYH6sHmVQh3ml2jbUXSijJJc+yhNtIXFCMMdagk=;
	h=Date:From:To:Cc:In-Reply-To:References:Subject:From;
	b=kGTZyWK9NxTBeFN83u6JR8u46jSt/HGQRh8X8Wc1W8Jdg2KABSt1+TzNn0aI5SpMH
	 YC6g6hC4pTUUh4iO7d0BWe6EU/6CD9gDrn/2cZbLXf9GD8C96WlkSZtyB9+Uj5lXDQ
	 2zI4nabQR1mYSnd7wNFL0P29KPd/+tTv3k0IpPbcvlXYLz5+LNdJqzEH9/7LllfE/q
	 kWDNnGBAbxkLC2Svs2CTIjvKWjL/GKEKvbflW65uivF0+22E7p8h4n1OTcpYvmWsRo
	 ngviNI4I7oTvLeOJgPXIgmRnGFEnlxjIuHmfvVHc8OKXfsOKwXF1AZ89Ey+5j0aEsg
	 JgIHauhOptjdw==
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfauth.phl.internal (Postfix) with ESMTP id 574D6F40069;
	Tue, 17 Feb 2026 05:27:11 -0500 (EST)
Received: from phl-imap-02 ([10.202.2.81])
  by phl-compute-01.internal (MEProxy); Tue, 17 Feb 2026 05:27:11 -0500
X-ME-Sender: <xms:f0KUafmP-W0tWKNjtMHllwpq6l4o81zaMJZFjcNebcAVCO-EpAuQ7g>
    <xme:f0KUadrWto3QOLEthKf1rWjt29SJdatJSw9P8UQ-UJSD2esZmb-hoOe-VFQuI9Xlf
    nckXZ7IHAnnrO90izWyoQOQH3PPVKVA-yRAopbWKakBUQJ5TnR_zBE>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgddvudelhedvucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepofggfffhvfevkfgjfhfutgfgsehtjeertdertddtnecuhfhrohhmpedftehrugcu
    uehivghshhgvuhhvvghlfdcuoegrrhgusgeskhgvrhhnvghlrdhorhhgqeenucggtffrrg
    htthgvrhhnpedvueehiedtvedtleekuddutefgffdtleetfeetveejveejieehfefhjeei
    jeefudenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpe
    grrhguodhmvghsmhhtphgruhhthhhpvghrshhonhgrlhhithihqdduieejtdehtddtjeel
    qdeffedvudeigeduhedqrghruggspeepkhgvrhhnvghlrdhorhhgseifohhrkhhofhgrrh
    gurdgtohhmpdhnsggprhgtphhtthhopeehpdhmohguvgepshhmthhpohhuthdprhgtphht
    thhopeigkeeisehkvghrnhgvlhdrohhrghdprhgtphhtthhopehkvgigvggtsehlihhsth
    hsrdhinhhfrhgruggvrggurdhorhhgpdhrtghpthhtohepugihohhunhhgsehrvgguhhgr
    thdrtghomhdprhgtphhtthhopehlihhnuhigqdgvfhhisehvghgvrhdrkhgvrhhnvghlrd
    horhhgpdhrtghpthhtoheplhhinhhugidqkhgvrhhnvghlsehvghgvrhdrkhgvrhhnvghl
    rdhorhhg
X-ME-Proxy: <xmx:f0KUac6_bu1irJOhkeuPf2MVEBvFMvF3dI7AXJJMWh2UeH7BIVZfPw>
    <xmx:f0KUaRkA1AVSX625YG9KqAx_e_IUfJHQXnPm4KyEW7Shthn1f82Cag>
    <xmx:f0KUaVTbKQHfhODebLnPjN9Mu3aVWvG-VlObfXpGfrJiuX2YBhWFAg>
    <xmx:f0KUaYFKPQcnu_fgHH30m8xE3dKdqBpIgI1XpVR7NASXTYPLuD5z-g>
    <xmx:f0KUaSFuahm6Waz9LKrgjPFmltNZEhvw2K78uP5inOA8rFZiT1CKSFtG>
Feedback-ID: ice86485a:Fastmail
Received: by mailuser.phl.internal (Postfix, from userid 501)
	id 1D43C700065; Tue, 17 Feb 2026 05:27:11 -0500 (EST)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-ThreadId: AR4vd3DIDa3F
Date: Tue, 17 Feb 2026 11:26:50 +0100
From: "Ard Biesheuvel" <ardb@kernel.org>
To: "Dave Young" <dyoung@redhat.com>
Cc: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org,
 kexec@lists.infradead.org, x86@kernel.org
Message-Id: <665dc599-8488-4761-b3c3-07b994cb82b8@app.fastmail.com>
In-Reply-To: 
 <CALu+AoTkGWXAokzXwo6C+6K1-mk3r9YA=WauXAggP628F_=ABQ@mail.gmail.com>
References: <aZQg_tRQmdKNadCg@darkstar.users.ipa.redhat.com>
 <824bf9d5-93d3-4791-a064-3852014a1264@app.fastmail.com>
 <CALu+AoRdo5E-irxymu7WAV+L=sKLbjnOXtLLe7RHWX-NZtjvNw@mail.gmail.com>
 <61f0c9ad-a435-4856-8ebe-d5a81f72330e@app.fastmail.com>
 <CALu+AoTkGWXAokzXwo6C+6K1-mk3r9YA=WauXAggP628F_=ABQ@mail.gmail.com>
Subject: Re: [PATCH] efi/x86-stub: store acpi_rsdp_addr in bootparams
Content-Type: text/plain
Content-Transfer-Encoding: 7bit



On Tue, 17 Feb 2026, at 11:01, Dave Young wrote:
> On Tue, 17 Feb 2026 at 17:20, Ard Biesheuvel <ardb@kernel.org> wrote:
>>
>>
>> On Tue, 17 Feb 2026, at 09:19, Dave Young wrote:
>> > Hi Ard,
>> >
>> > On Tue, 17 Feb 2026 at 16:10, Ard Biesheuvel <ardb@kernel.org> wrote:
>> >>
>> >> Hi Dave,
>> >>
>> >> On Tue, 17 Feb 2026, at 09:04, Dave Young wrote:
>> >> > Kernel panic occurs during a kexec reboot when EFI runtime services
>> >> > are not enabled in the first kernel. The issue is that the second
>> >> > kernel cannot find the ACPI RSDP address during boot.
>> >> >
>> >> > In legacy boot, the acpi_rsdp_addr is set in early x86 boot code.
>> >> > However, kernel decompression has moved to the EFI stub for EFI boot.
>> >> > Therefore, the x86 EFI stub must also be updated to store the
>> >> > acpi_rsdp_addr in the boot parameters to ensure the kexec kernel
>> >> > can find it.
>> >> >
>> >> > (Note: If the pre-kexec kernel was itself a kexec boot, the later kexec
>> >> > reboot will still utilize the legacy decompressor path, so the original
>> >> > code remains functional though some cleanups can be done later.)
>> >> >
>> >> > Signed-off-by: Dave Young <dyoung@redhat.com>
>> >> > ---
>> >> >  drivers/firmware/efi/libstub/x86-stub.c |   18 ++++++++++++++++++
>> >> >  1 file changed, 18 insertions(+)
>> >> >
>> >>
>> >> If this issue is kexec-specific, can we move this to where the kexec code prepares the boot_params struct for the next kernel?
>> >>
>> >
>> > The kexec use case is it depends on the pre-kexec kernel saving it
>> > during boot for noefi case.  I do not have a better idea to do it in
>> > kexec code for the time being.
>>
>> How about something like this?
>
> Thanks!  It works for me, however the legacy kexec_load syscall still
> failed with a panic I did not dig into the root cause yet, I supposed
> it will find the rsdp from /sys/firmware/efi/systab file, maybe some
> userspace code bug.
>
> Anyway I'm fine with this fix,  would you like to send a formal patch
> since you proposed it?  Otherwise I will resend with the changes.
>

Excellent. I'll queue it with a link to this thread.
