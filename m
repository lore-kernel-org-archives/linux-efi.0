Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6BCE36683E;
	Tue, 24 Feb 2026 09:56:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771926983; cv=none; b=aQVqOgOZLVXRVGJ3szkeUPLDLyHal2e3gOwx6s534cO/H7Q3xyqr3LSqN+rr7c5lCjChJ8U5YO6t6mXnXsiZ2QIP+bbqxlMwYWqdjPERoHHuGw9TEFTHxUlb2WJ5u8F36tlwjjmxCD5UrrzS/vJANs3Q9HRbJgYkZUcI9i+Y4LM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771926983; c=relaxed/simple;
	bh=K3RDjAlZowo+4rYvPnOOa5kXWHplgjhbrLLqCtnsTA0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FiiSWnb4yOCVxZAh1JOUqRZm32lYYV7HIzab2oTAg7fwHq1N1lswzXktCwtMVRkuZ1cAq4rPyDo+uNUgusD0FB/7iNJR6ZhcZ9HFasm+AvzMD0u9kbj1yHuvVAaRxgDIpoctmh8byceBeie7nxspgozd3fzBE7pFkwIq+6sybFk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kklVnf5U; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kklVnf5U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09C49C116D0;
	Tue, 24 Feb 2026 09:56:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771926983;
	bh=K3RDjAlZowo+4rYvPnOOa5kXWHplgjhbrLLqCtnsTA0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=kklVnf5UCe2Ljmnyt2i0NloaCbFvUnJlmKMizwcQtrZT2U3zTmCSy0VgOmSjjCtHZ
	 j0EIcKGW8lRtqwzfV+vEUJdLu/o7sB++sXBQpJNjPNRQHG86G+NopNAzT77MGSLTTq
	 JABx/8iY8+nQV4ke9Pv1Cukb2sFTn6RShrkSmkuDfik2mQSXFJH7rX7n60klv0bZSV
	 w+VDtLyROzo48mj+8gmH2mg4drUHk0Q/a9kxitZC3Bia1/BzgWj1Npx+urRr6LYk8q
	 cW50O4U1pO0pKs4E3E/rwW+BwD69hP+4qVU9ZRZy2MJ5xJFjf9bvNY1nDAf9RnsYZM
	 k5/s+FtOHhu6Q==
Date: Tue, 24 Feb 2026 11:56:15 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Ard Biesheuvel <ardb@kernel.org>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
	Benjamin Herrenschmidt <benh@kernel.crashing.org>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Ilias Apalodimas <ilias.apalodimas@linaro.org>,
	Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>,
	Thomas Gleixner <tglx@kernel.org>, linux-efi@vger.kernel.org,
	linux-mm@kvack.org, stable@vger.kernel.org
Subject: Re: [PATCH] x86/efi: defer freeing of boot services memory
Message-ID: <aZ11vw7mYmX1onEL@kernel.org>
References: <20260223075219.2348035-1-rppt@kernel.org>
 <b6f4edf5-7587-45d7-b81a-590d4f3d1ddd@app.fastmail.com>
 <aZwyNAbEqb8ZwLUM@kernel.org>
 <e2ad0845-2f87-418a-9f87-5ce619e004ef@app.fastmail.com>
 <aZw8xSI-TM-Gz84t@kernel.org>
 <bfe487fe-6868-4215-b5be-99a0360e9bd2@app.fastmail.com>
 <aZ1vWEgJNwc2nrrA@kernel.org>
 <3a01d817-e08c-45ec-b5a7-4a8d9ecd0fc6@app.fastmail.com>
 <aZ11J7D_iBuG_qjC@kernel.org>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aZ11J7D_iBuG_qjC@kernel.org>

On Tue, Feb 24, 2026 at 11:53:50AM +0200, Mike Rapoport wrote:
> On Tue, Feb 24, 2026 at 10:29:59AM +0100, Ard Biesheuvel wrote:
> > 
> > 
> > On Tue, 24 Feb 2026, at 10:28, Mike Rapoport wrote:
> > > On Mon, Feb 23, 2026 at 01:18:41PM +0100, Ard Biesheuvel wrote:
> > >> On Mon, 23 Feb 2026, at 12:40, Mike Rapoport wrote:
> > >> > On Mon, Feb 23, 2026 at 12:17:22PM +0100, Ard Biesheuvel wrote:
> > >> >>
> > >> >> > I wasn't sure it's Ok to only unmap them, but leave in efi.memmap, that's
> > >> >> > why I didn't use the existing EFI memory map.
> > >> >> >
> > >> >> > Now thinking about it, if the unmapping can happen later, maybe we'll just
> > >> >> > move the entire efi_free_boot_services() to an initcall?
> > >> >> 
> > >> >> As long as it is pre-SMP, as that code also contains a quirk to allocate
> > >> >> the real mode trampoline if all memory below 1 MB is used for boot
> > >> >> services.
> > >> >
> > >> > initcall is long after SMP. It the real mode trampoline allocation is the
> > >> > only thing that should happen pre-SMP?
> > >> 
> > >> early_initcall() should be early enough, those run before SMP init.
> > >
> > > I don't think so. All initcalls run quite late in boot, early ones just run
> > > before the others.
> > > 
> > 
> > It is documented as running before SMP. If that is no longer true, we should fix the documentation.
> 
> Ah, my bad, it is running before SMP. 

But then it also runs before page_alloc_init_late(), and it's too early for
free reserved memory with CONFIG_DEFERRED_STRUCT_INIT=y :(

-- 
Sincerely yours,
Mike.
