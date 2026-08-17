Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C74743B3FF;
	Mon, 17 Aug 2026 14:52:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786978355; cv=none; b=DesLTNv5mvTIhLJ1YwCTzHXOl/K/xGMb+sau5Gu3zyitDWQhrZxCvByhG5auqInuigDiQoY9D9c3UZIrGNJLYM1VxCgNr82Hw5QOa1pfaqW0T5ec6qGLeLCp4AcCgyHB7GggpxOS1kujx9ON49o942CsI6tfI7UiRznPQNfed8k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786978355; c=relaxed/simple;
	bh=qM37NYUNjGaWh0mG8HctDVCH9I/Zz7bcybyjBU0W6Gs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=T6GRowI44l/q/5oOHVqNenfUAYw9GTbreB6Fg0tDnYusAGDG5iEcqPeJw4igBtINdCczNP+WszBkAVWrn7byvbiszAMXqeefuRwl3HP2ZCquNyf9AJ6Ifo3FgxLptqwBN2j9851Sd9iacKJiR5k7IogHyOu447vKpWt3mosDwDI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CBoIq9lL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CBoIq9lL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5F371F00A3A;
	Mon, 17 Aug 2026 14:52:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786978354;
	bh=wnsRgd67O5ijJMELnbh+i0cmgBbItG68MRY6qRnSMzA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=CBoIq9lLGcS1UGfR4RR+GyS2qSFm8aL5eb+9zilvIc89rv295t+J+1iuJ2RdNYN95
	 G25ofttDY+XuK1AH5qG92ZIzkAEkONWdMALeOvk0NT42gNuHCzqWLWd9KbVPWOCw5p
	 ur5Gu+9bLyhlnKL13dobkZAf0L4xSVlHOROg4JpvVPf87NF4JB3luCj1ItTd5YRhqD
	 irW7P5rpyC+dFSJrxnBWYO+S7tHEmLwA4OetakxSOUZC20faUsFylpFkqnW+VDbmHA
	 p+smz5BpBO2zuDaOYjkXj2gF6+Nz/EzxK2oHF75hOI3g7i2UrPEwzXA5il4kD7inkq
	 iNIMSvK5+lSDQ==
Date: Mon, 17 Aug 2026 09:52:31 -0500
From: Rob Herring <robh@kernel.org>
To: Gregory Price <gourry@gourry.net>
Cc: Pratyush Yadav <pratyush@kernel.org>, Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Mike Rapoport <rppt@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Alexander Graf <graf@amazon.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Thomas Gleixner <tglx@kernel.org>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>, Ard Biesheuvel <ardb@kernel.org>,
	Ilias Apalodimas <ilias.apalodimas@linaro.org>,
	Saravana Kannan <saravanak@kernel.org>,
	Arnd Bergmann <arnd@arndb.de>, Baoquan He <baoquan.he@linux.dev>,
	x86@kernel.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, kexec@lists.infradead.org,
	linux-mm@kvack.org, linux-efi@vger.kernel.org,
	devicetree@vger.kernel.org, linux-arch@vger.kernel.org
Subject: Re: [PATCH 0/4] kho: rename "scratch" to "bootmem"
Message-ID: <20260817145231.GA579285-robh@kernel.org>
References: <20260811162642.3504565-1-pratyush@kernel.org>
 <aoMdJ7hpr1GonLz8@gourry-fedora-PF4VCD3F>
Precedence: bulk
X-Mailing-List: linux-efi@vger.kernel.org
List-Id: <linux-efi.vger.kernel.org>
List-Subscribe: <mailto:linux-efi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-efi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aoMdJ7hpr1GonLz8@gourry-fedora-PF4VCD3F>

On Mon, Aug 17, 2026 at 10:42:00AM -0400, Gregory Price wrote:
> On Tue, Aug 11, 2026 at 06:26:36PM +0200, Pratyush Yadav wrote:
> > From: "Pratyush Yadav (Google)" <pratyush@kernel.org>
> > 
> > The term "KHO scratch" is vague and overloaded. It does not accurately
> > describe what the memory is for. This was discussed previously at [0].
> > The conclusion was to rename "KHO scratch" to "KHO bootmem", since this
> > is memory passed by the previous kernel for early boot allocations.
> > 
> 
> This seems like a lot of churn to just rename some stuff, especially for
> a term "scratch" which is very much understood to mean "temporary
> working memory region" in common computing parlance.
> 
> The boot param name change would also cause breakage for existing
> systems that update and depend on the scratch parameter.
> 
> Is there a non-verbiage reason to justify these changes?  Living with
> "scratch" seems better than potentially breaking folks.

I don't think these are the first breaking changes. And if the changes 
are fine, then that means more breaking changes are fine, too. So why is 
this upstream at all until the design is settled?

Rob
