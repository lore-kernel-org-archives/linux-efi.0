Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AA2D459AFC;
	Tue, 18 Aug 2026 10:59:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787050744; cv=none; b=Mwe0fhp+E6DISGbowv4d7+RHCbwLNQjlIzXqicbJfYmhL7KzbjgZ0zHNdxfT3Q8hBHxMtjPeS/PcUNpr524EPDSFTwCYcJ0pbhfVdPBcjEL+uQnWENrCKqEZYMI2OQ17BsADjMNkK5bV7UJOPsE/amgdWZxuxRkRK3gFkGQBwDg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787050744; c=relaxed/simple;
	bh=j96hBrbIXKCqK7PkeQkocKh7geO0CLrQBKNjPtqd4e4=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=YMTPCEK50qktlubNu6IDM0fx4gjhSwMFarsN5VC0MeEezFqgz22UVsrm2hQIN8BwOhmzfBXNNLv2/cw6I5VZhhH3iP2Dzyntejyf7rkBvL22LSBVGpWrwvsEOR/fWGRkL8137HSh46KidiMavN9W3U/s9oTc13y7D3c7hZL+YFE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ihoilFAp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ihoilFAp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F3811F000E9;
	Tue, 18 Aug 2026 10:58:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787050742;
	bh=Koz3r/AfThNLRrBgrtFERGCjlw/bQbRflD0M4YMQKNo=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=ihoilFApSOAE34vYAawnEXEPs2f7u8XzfhkPsgG2g14u5Q5sWxPAMOf71YALTPv8v
	 fZyOdM6N19EY1DCuJzEcAgnNo9BvWctVjcxlxlZit/W1UkRoq7AnILj/k5I3fXHckj
	 grBgpSIdu0Uxj74rIVP2vJjPjRmaX/GeuFFr/SaBlUOHJG0teMz5FRbtdoS1mfTTJB
	 rv0RjYc0NXjBPQIsE0OKcZEy6Z5T+gJWmnkPZfyepE74gvHw2bKL7FMJuDxlOVEaTm
	 mjg1MlR4odsf+vaZlanjE2Ww8L2FXJYF7SZMeEpBWtRQBMi5LcfJ29f2343Zn26qLX
	 CFZBDHwCrHJwA==
From: Pratyush Yadav <pratyush@kernel.org>
To: Rob Herring <robh@kernel.org>
Cc: Gregory Price <gourry@gourry.net>,  Pratyush Yadav
 <pratyush@kernel.org>,  Jonathan Corbet <corbet@lwn.net>,  Shuah Khan
 <skhan@linuxfoundation.org>,  Mike Rapoport <rppt@kernel.org>,  Pasha
 Tatashin <pasha.tatashin@soleen.com>,  Alexander Graf <graf@amazon.com>,
  Andrew Morton <akpm@linux-foundation.org>,  David Hildenbrand
 <david@kernel.org>,  Lorenzo Stoakes <ljs@kernel.org>,  "Liam R. Howlett"
 <liam@infradead.org>,  Vlastimil Babka <vbabka@kernel.org>,  Suren
 Baghdasaryan <surenb@google.com>,  Michal Hocko <mhocko@suse.com>,  Thomas
 Gleixner <tglx@kernel.org>,  Ingo Molnar <mingo@redhat.com>,  Borislav
 Petkov <bp@alien8.de>,  Dave Hansen <dave.hansen@linux.intel.com>,  "H.
 Peter Anvin" <hpa@zytor.com>,  Ard Biesheuvel <ardb@kernel.org>,  Ilias
 Apalodimas <ilias.apalodimas@linaro.org>,  Saravana Kannan
 <saravanak@kernel.org>,  Arnd Bergmann <arnd@arndb.de>,  Baoquan He
 <baoquan.he@linux.dev>,  x86@kernel.org,  linux-doc@vger.kernel.org,
  linux-kernel@vger.kernel.org,  kexec@lists.infradead.org,
  linux-mm@kvack.org,  linux-efi@vger.kernel.org,
  devicetree@vger.kernel.org,  linux-arch@vger.kernel.org
Subject: Re: [PATCH 0/4] kho: rename "scratch" to "bootmem"
In-Reply-To: <20260817145231.GA579285-robh@kernel.org> (Rob Herring's message
	of "Mon, 17 Aug 2026 09:52:31 -0500")
References: <20260811162642.3504565-1-pratyush@kernel.org>
	<aoMdJ7hpr1GonLz8@gourry-fedora-PF4VCD3F>
	<20260817145231.GA579285-robh@kernel.org>
Date: Tue, 18 Aug 2026 12:58:55 +0200
Message-ID: <2vxz4igr1yq8.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

On Mon, Aug 17 2026, Rob Herring wrote:

> On Mon, Aug 17, 2026 at 10:42:00AM -0400, Gregory Price wrote:
>> On Tue, Aug 11, 2026 at 06:26:36PM +0200, Pratyush Yadav wrote:
>> > From: "Pratyush Yadav (Google)" <pratyush@kernel.org>
>> > 
>> > The term "KHO scratch" is vague and overloaded. It does not accurately
>> > describe what the memory is for. This was discussed previously at [0].
>> > The conclusion was to rename "KHO scratch" to "KHO bootmem", since this
>> > is memory passed by the previous kernel for early boot allocations.
>> > 
>> 
>> This seems like a lot of churn to just rename some stuff, especially for
>> a term "scratch" which is very much understood to mean "temporary
>> working memory region" in common computing parlance.

Gregory,

Maybe. The people who work with the code on a daily basis (me, Mike,
Pasha) think the rename is worthwhile because it helps us grok the code
better.

I think patch 1 and 2 should go in for sure. They make a noticeable
improvement to memblock's code. Without that, memblock might have some
memory marked as MEMBLOCK_KHO_SCRATCH that is part of "scratch" we got
from KHO, and then some other memory also marked as MEMBLOCK_KHO_SCRATCH
that we discovered at boot. Then later, the "scratch from KHO" needs to
be initialized in a different way from "scratch discovered at boot". The
rename to NOPRSRV makes it way more clear what the properties of the
memory are and how memblock should use it.

For patch 3, I am honestly surprised at how large it ended up being. But
I am in principle opposed to the idea that we should not do any
housekeeping because it might cause "churn". So I think if the end
result is better then churn shouldn't stop us.

Of course patch 3 has a lot of potential for bikeshedding so we can
argue all day on what is better.

>> 
>> The boot param name change would also cause breakage for existing
>> systems that update and depend on the scratch parameter.
>> 
>> Is there a non-verbiage reason to justify these changes?  Living with
>> "scratch" seems better than potentially breaking folks.

I renamed the commandline option because similar things have been done
in the past for other options too.

See commit c5bfece2d612 ("nohz: Switch from "extended nohz" to "full
nohz" based naming") for example. It renamed "nohz_extended" to
"nohz_full" because it is "a bit opaque and vague".

Or commit 9406415f46f6 ("sched/debug: Rename the sched_debug parameter
to sched_verbose"). Or a94e88cdd805 ("ACPICA: Tables: Avoid SSDT
installation with acpi_gbl_disable_ssdt_table_load."). Or 632ff6170647
("x86/microcode: Add microcode= cmdline parsing"). There are a handful
more.

So I think there is a bit of history of command line options being
renamed to names the developers think are better.

Also, I would imagine very few people are using kho_scratch= blindly.
Since kho=on already does a pretty good job of automatically selecting
the sizes, most people should not be using this option at all. Manual
sizing of scratch areas is tricky and should only be done very carefully
by observing each system's characteristics. And the numbers should be
re-calibrated on each kernel upgrade since a new kernel might use more
(or less) memory at boot. So really, I think the change is a lot less
disruptive than you think.

That said, I am not opposed to keeping backwards compatibility if
someone _does_ complain.

> I don't think these are the first breaking changes. And if the changes 

Rob,

What do you mean? None of the KHO's commandline options have changed
before. And KHO has no uAPI to break in the first place.

> are fine, then that means more breaking changes are fine, too. So why is 
> this upstream at all until the design is settled?
>
> Rob

-- 
Regards,
Pratyush Yadav
