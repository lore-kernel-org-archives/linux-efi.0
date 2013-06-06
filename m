From: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 4/4] x86, efi: Map runtime services 1:1
Date: Thu, 06 Jun 2013 12:38:10 -0700
Message-ID: <51B0E522.4070005@zytor.com>
References: <1370177770-26661-1-git-send-email-bp@alien8.de> <1370177770-26661-5-git-send-email-bp@alien8.de> <20130606131439.GI30420@console-pimps.org> <20130606132908.GE20972@pd.tnic> <20130606155822.GH20972@pd.tnic> <51B0E2D4.3040007@zytor.com> <20130606193612.GM20972@pd.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130606193612.GM20972-fF5Pk5pvG8Y@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
Cc: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>, Linux EFI <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>, Jiri Kosina <jkosina-AlSwsSmVLrQ@public.gmane.org>, X86-ML <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Borislav Petkov <bp-l3A5Bk7waGM@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 06/06/2013 12:36 PM, Borislav Petkov wrote:
> On Thu, Jun 06, 2013 at 12:28:20PM -0700, H. Peter Anvin wrote:
>> Or we could materialize mappings for this specific PGD. However,
>> adding a read of %cr3 in __do_page_fault sounds expensive.
> 
> Yes, I think we want to make sure all mappings are there when we do an
> EFI runtime call so that we never #PF while it executes.
> 
> Matt mentioned on IRC that the it could be that his EFI runtime is
> referencing EFI_RESERVED area which we don't map. However, we need to
> confirm/disprove that first, as it is currently only a hunch.

If it is true, then maybe a #PF handler which materializes mappings on
demand might be the right thing to do.

Again, it would be interesting to stop a WinX VM in the process of doing
an EFI call and see exactly what it has set up in its page tables.

	-hpa
