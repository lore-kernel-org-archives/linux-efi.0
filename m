From: Matt Fleming <matt@codeblueprint.co.uk>
Subject: Re: [PATCH] x86: setup: extend low identity map to cover whole
 kernel range
Date: Wed, 14 Oct 2015 22:04:19 +0100
Message-ID: <20151014210419.GG2782@codeblueprint.co.uk>
References: <1444822245-6784-1-git-send-email-pbonzini@redhat.com>
 <20151014135211.GB2782@codeblueprint.co.uk>
 <561E66CD.1050301@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <561E66CD.1050301@redhat.com>
Sender: stable-owner@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, x86@kernel.org, stable@vger.kernel.org, lersek@redhat.com, matt.fleming@intel.com, bp@suse.de, linux-efi@vger.kernel.org, Andy Lutomirski <luto@amacapital.net>
List-Id: linux-efi@vger.kernel.org

On Wed, 14 Oct, at 04:29:33PM, Paolo Bonzini wrote:
> 
> On 14/10/2015 15:52, Matt Fleming wrote:
> >> > However, for non-PAE kernels there is no guarantee that the identity
> >> > mapping in the initial_page_table extends as far as the GDT; in this
> >> > case, accesses to the GDT will cause a page fault (which quickly becomes
> >> > a triple fault).  Fix this by copying the kernel mappings from
> >> > swapper_pg_dir to initial_page_table twice, both at PAGE_OFFSET and at
> >> > identity mapping.
> >  
> > Oops, good catch guys. This is clearly a bug, but...
> > 
> > ... I'm a little surprised you managed to trigger this at all, because
> > the GDT we load in efi_call_phys_prolog() is part of the per-cpu data
> > section and therefore part of the kernel image.
> 
> Only until setup_percpu, which is earlier than SetVirtualAddressMap.
> For example, I get:
> 
>   setup_percpu: NR_CPUS:8 nr_cpumask_bits:8 nr_cpu_ids:1 nr_node_ids:1
>   PERCPU: Embedded 18 pages/cpu @c728e000 s41800 r0 d31928 u73728
>                                   ^^^^^^^
> but the kernel image ends at 0x037fffff.
>
> The GDT is 0xc728e000 in this run, so the GDT is at the beginning of the
> relocated percpu area.

Ah, good point. I completely missed that the percpu sections get
relocated.

-- 
Matt Fleming, Intel Open Source Technology Center
