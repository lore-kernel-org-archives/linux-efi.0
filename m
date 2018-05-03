From: Mimi Zohar <zohar@linux.vnet.ibm.com>
Subject: Re: [PATCH v5 2/5] efi: Add embedded peripheral firmware support
Date: Thu, 03 May 2018 19:02:43 -0400
Message-ID: <1525388563.3539.97.camel@linux.vnet.ibm.com>
References: <20180429093558.5411-1-hdegoede@redhat.com>
         <20180429093558.5411-3-hdegoede@redhat.com>
         <1525185374.5669.49.camel@linux.vnet.ibm.com>
         <dc122066-9973-a1be-3456-6d6181a8fc9f@redhat.com>
         <1525202847.5669.64.camel@linux.vnet.ibm.com>
         <20180503222329.GD27853@wotan.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180503222329.GD27853@wotan.suse.de>
Sender: linux-kernel-owner@vger.kernel.org
To: "Luis R. Rodriguez" <mcgrof@kernel.org>
Cc: Hans de Goede <hdegoede@redhat.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, Peter Jones <pjones@redhat.com>, Dave Olsthoorn <dave@bewaar.me>, Will Deacon <will.deacon@arm.com>, Andy Lutomirski <luto@kernel.org>, Matt Fleming <matt@codeblueprint.co.uk>, David Howells <dhowells@redhat.com>, Josh Triplett <josh@joshtriplett.org>, dmitry.torokhov@gmail.com, mfuzzey@parkeon.com, Kalle Valo <kvalo@codeaurora.org>, Arend Van Spriel <arend.vanspriel@broadcom.com>, Linus Torvalds <torvalds@linux-foundation.org>, nbroeking@me.com, bjorn.andersson@linaro.org, Torsten Duwe <duwe@suse.de>, Kees Cook <keesco>
List-Id: linux-efi@vger.kernel.org

On Thu, 2018-05-03 at 22:23 +0000, Luis R. Rodriguez wrote:
> On Tue, May 01, 2018 at 03:27:27PM -0400, Mimi Zohar wrote:
> > On Tue, 2018-05-01 at 21:11 +0200, Hans de Goede wrote:
> > > Only the pre hook?  I believe the post-hook should still be called too,
> > > right? So that we've hashes of all loaded firmwares in the IMA core.
> > 
> > Good catch!  Right, if IMA-measurement is enabled, then we would want
> > to add the measurement.
> 
> Mimi, just a heads up, we only use the post hook for the syfs fallback
> mechanism, ie, we don't even use the post hook for direct fs lookup.
> Do we want that there?

The direct fs lookup calls kernel_read_file_from_path(), which calls
the security_kernel_read_file() and security_kernel_post_read_file()
hooks.  So there is no need to add a direct call to either of these
security calls.

Mimi



  
