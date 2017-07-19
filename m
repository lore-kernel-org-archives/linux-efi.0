From: Daniel Kiper <daniel.kiper@oracle.com>
Subject: Re: [PATCH 4.12 26/84] x86/xen/efi: Initialize only the EFI struct
 members used by Xen
Date: Wed, 19 Jul 2017 12:37:47 +0200
Message-ID: <20170719103747.GZ4448@olila.local.net-space.pl>
References: <20170719092322.362625377@linuxfoundation.org>
 <20170719092323.396710042@linuxfoundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170719092323.396710042@linuxfoundation.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org, Boris Ostrovsky <boris.ostrovsky@oracle.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Linus Torvalds <torvalds@linux-foundation.org>, Peter Zijlstra <peterz@infradead.org>, Thomas Gleixner <tglx@linutronix.de>, andrew.cooper3@citrix.com, jgross@suse.com, linux-efi@vger.kernel.org, matt@codeblueprint.co.uk, xen-devel@lists.xenproject.org, Ingo Molnar <mingo@kernel.org>
List-Id: linux-efi@vger.kernel.org

Hey Greg,

On Wed, Jul 19, 2017 at 11:43:32AM +0200, Greg Kroah-Hartman wrote:
> 4.12-stable review patch.  If anyone has any objections, please let me know.

Why did you skip this patch for 4.11? IMO it should be applied there too.

Daniel
