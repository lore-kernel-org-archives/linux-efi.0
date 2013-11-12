From: Pekka Enberg <penberg@kernel.org>
Subject: Re: [PATCH 0/3] Early use of boot service memory
Date: Tue, 12 Nov 2013 12:37:29 +0200
Message-ID: <CAOJsxLEoN2uYR9V3bowv2O7F8L5t+kVrdehHW151cEcfgx-oJg@mail.gmail.com>
References: <1384222558-38527-1-git-send-email-jerry.hoemann@hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <1384222558-38527-1-git-send-email-jerry.hoemann@hp.com>
Sender: linux-doc-owner@vger.kernel.org
To: Jerry Hoemann <jerry.hoemann@hp.com>
Cc: Rob Landley <rob@landley.net>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, x86 maintainers <x86@kernel.org>, Matt Fleming <matt.fleming@intel.com>, Yinghai Lu <yinghai@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, "list@ebiederm.org:DOCUMENTATION <linux-doc@vger.kernel.org>,
	list@ebiederm.org:MEMORY MANAGEMENT <linux-mm@kvack.org>," <linux-doc@vger.kernel.org>, linux-efi@vger.kernel.org, Vivek Goyal <vgoyal@redhat.com>, LKML <linux-kernel@vger.kernel.org>
List-Id: linux-efi@vger.kernel.org

On Tue, Nov 12, 2013 at 4:15 AM, Jerry Hoemann <jerry.hoemann@hp.com> wrote:
> Some platform have firmware that violates UEFI spec and access boot service
> code or data segments after the system has called Exit Boot Services.
> The call to efi_reserve_boot_services in setup_arch is a work around to
> avoid using boot service memory until after the kernel has done
> Set Virtual Map.
>
> However, this reservation fragments memory which can cause
> large allocations early in boot (e.g. crash kernel) to fail.

What is the exact problem you're trying to solve here? How will the
problem be fixed for platforms that break the UEFI specification?

                        Pekka
