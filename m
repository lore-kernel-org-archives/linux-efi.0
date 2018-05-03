From: "Luis R. Rodriguez" <mcgrof@kernel.org>
Subject: Re: [PATCH v5 2/5] efi: Add embedded peripheral firmware support
Date: Thu, 3 May 2018 22:23:29 +0000
Message-ID: <20180503222329.GD27853@wotan.suse.de>
References: <20180429093558.5411-1-hdegoede@redhat.com>
 <20180429093558.5411-3-hdegoede@redhat.com>
 <1525185374.5669.49.camel@linux.vnet.ibm.com>
 <dc122066-9973-a1be-3456-6d6181a8fc9f@redhat.com>
 <1525202847.5669.64.camel@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1525202847.5669.64.camel@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: Hans de Goede <hdegoede@redhat.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, "Luis R . Rodriguez" <mcgrof@kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, Peter Jones <pjones@redhat.com>, Dave Olsthoorn <dave@bewaar.me>, Will Deacon <will.deacon@arm.com>, Andy Lutomirski <luto@kernel.org>, Matt Fleming <matt@codeblueprint.co.uk>, David Howells <dhowells@redhat.com>, Josh Triplett <josh@joshtriplett.org>, dmitry.torokhov@gmail.com, mfuzzey@parkeon.com, Kalle Valo <kvalo@codeaurora.org>, Arend Van Spriel <arend.vanspriel@broadcom.com>, Linus Torvalds <torvalds@linux-foundation.org>, nbroeking@me.com, bjorn.andersson@linaro.org
List-Id: linux-efi@vger.kernel.org

On Tue, May 01, 2018 at 03:27:27PM -0400, Mimi Zohar wrote:
> On Tue, 2018-05-01 at 21:11 +0200, Hans de Goede wrote:
> > Only the pre hook?  I believe the post-hook should still be called too,
> > right? So that we've hashes of all loaded firmwares in the IMA core.
> 
> Good catch!  Right, if IMA-measurement is enabled, then we would want
> to add the measurement.

Mimi, just a heads up, we only use the post hook for the syfs fallback
mechanism, ie, we don't even use the post hook for direct fs lookup.
Do we want that there?

  Luis
