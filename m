From: Matt Fleming <matt@codeblueprint.co.uk>
Subject: Re: kexec regression since 4.9 caused by efi
Date: Thu, 16 Mar 2017 12:15:32 +0000
Message-ID: <20170316121532.GE6261@codeblueprint.co.uk>
References: <20170308201616.GC8598@vader>
 <20170309063806.GB17257@dhcp-128-65.nay.redhat.com>
 <20170309095408.GA17883@vader>
 <CAKv+Gu-gRmt=Vq=QCcT5ETY9DwLzJe0f4gHR_9sFMKX7-vK++w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAKv+Gu-gRmt=Vq=QCcT5ETY9DwLzJe0f4gHR_9sFMKX7-vK++w@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Omar Sandoval <osandov@osandov.com>, Dave Young <dyoung@redhat.com>, Ingo Molnar <mingo@kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, kernel-team@fb.com, "kexec@lists.infradead.org" <kexec@lists.infradead.org>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>
List-Id: linux-efi@vger.kernel.org

On Thu, 09 Mar, at 12:53:36PM, Ard Biesheuvel wrote:
> 
> Hi Omar,
> 
> Thanks for tracking this down.
> 
> I wonder if this is an unintended side effect of the way we repurpose
> the EFI_MEMORY_RUNTIME attribute in efi_arch_mem_reserve(). AFAIUI,
> splitting memory map entries should only be necessary for regions that
> are not runtime memory regions to begin with, and so whether their
> virtual mapping address makes sense or not should be irrelevant.
> 
> Perhaps this only illustrates my lack of understanding of the x86 way
> of doing this, so perhaps Matt can shed some light on this?

Sorry for the delay.

Yes, Ard is correct. It's not necessary to split/reserve memory
regions that already have the EFI_MEMORY_RUNTIME attribute.
