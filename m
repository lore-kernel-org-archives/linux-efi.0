From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH] x86: setup: extend low identity map to cover whole kernel
 range
Date: Wed, 14 Oct 2015 16:29:33 +0200
Message-ID: <561E66CD.1050301@redhat.com>
References: <1444822245-6784-1-git-send-email-pbonzini@redhat.com>
 <20151014135211.GB2782@codeblueprint.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20151014135211.GB2782@codeblueprint.co.uk>
Sender: stable-owner@vger.kernel.org
To: Matt Fleming <matt@codeblueprint.co.uk>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, x86@kernel.org, stable@vger.kernel.org, lersek@redhat.com, matt.fleming@intel.com, bp@suse.de, linux-efi@vger.kernel.org, Andy Lutomirski <luto@amacapital.net>
List-Id: linux-efi@vger.kernel.org



On 14/10/2015 15:52, Matt Fleming wrote:
>> > However, for non-PAE kernels there is no guarantee that the identity
>> > mapping in the initial_page_table extends as far as the GDT; in this
>> > case, accesses to the GDT will cause a page fault (which quickly becomes
>> > a triple fault).  Fix this by copying the kernel mappings from
>> > swapper_pg_dir to initial_page_table twice, both at PAGE_OFFSET and at
>> > identity mapping.
>  
> Oops, good catch guys. This is clearly a bug, but...
> 
> ... I'm a little surprised you managed to trigger this at all, because
> the GDT we load in efi_call_phys_prolog() is part of the per-cpu data
> section and therefore part of the kernel image.

Only until setup_percpu, which is earlier than SetVirtualAddressMap.
For example, I get:

  setup_percpu: NR_CPUS:8 nr_cpumask_bits:8 nr_cpu_ids:1 nr_node_ids:1
  PERCPU: Embedded 18 pages/cpu @c728e000 s41800 r0 d31928 u73728
                                  ^^^^^^^
but the kernel image ends at 0x037fffff.

The GDT is 0xc728e000 in this run, so the GDT is at the beginning of the
relocated percpu area.

In the above run, the FS base that switch_to_new_gdt loads is 0x551C000.
 You have 0x728E000 - 0x551C000 = 0x1D72000, and from tracing I see that
one of the GDT values that is loaded very early is exactly 0xC1D72000.
That _is_ inside the kernel image of course when you remove PAGE_OFFSET.

Paolo
