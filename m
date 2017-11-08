From: "AKASHI, Takahiro" <takahiro.akashi-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: Firmware signing -- Re: [PATCH 00/27] security, efi: Add kernel
 lockdown
Date: Wed, 8 Nov 2017 15:15:54 +0900
Message-ID: <20171108061551.GD7859@linaro.org>
References: <1509660086.3416.15.camel@linux.vnet.ibm.com>
 <150842463163.7923.11081723749106843698.stgit@warthog.procyon.org.uk>
 <14219.1509660259@warthog.procyon.org.uk>
 <1509660641.3416.24.camel@linux.vnet.ibm.com>
 <20171107230700.GJ22894@wotan.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20171107230700.GJ22894-B4tOwbsTzaBolqkO4TVVkw@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Luis R. Rodriguez" <mcgrof-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Mimi Zohar <zohar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, gnomes-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org, linux-efi <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matthew Garrett <mjg59-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

Luis,

Thank you for this heads-up.

On Wed, Nov 08, 2017 at 12:07:00AM +0100, Luis R. Rodriguez wrote:
> On Thu, Nov 02, 2017 at 06:10:41PM -0400, Mimi Zohar wrote:
> > On Thu, 2017-11-02 at 22:04 +0000, David Howells wrote:
> > > Mimi Zohar <zohar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org> wrote:
> > > 
> > > > > Only validly signed device firmware may be loaded.
> > > > 
> > > > fw_get_filesystem_firmware() calls kernel_read_file_from_path() to
> > > > read the firmware, which calls into the security hooks. Is there
> > > > another place that validates the firmware signatures.  I'm not seeing
> > > > which patch requires firmware to be signed?
> > > 
> > > Luis has a set of patches for this.  However, I'm not sure if that's going
> > > anywhere at the moment.  Possibly I should remove this from the manpage for
> > > the moment.
> 
> Remove it for now. The state of of affairs for firmware signing is complex given
> that we first wanted to address how to properly grow the API without making
> the API worse. This in and of itself was an effort, and that effort also
> evaluated two different development paradigms:
> 
> 	o functional API
> 	o data driven API
> 
> I only recently was convinced that functional API should be used, even for
> commonly used exported symbols,

Are you?
I haven't answered Linus' question, but my concern about functional APIs,
as far as firmware signing goes, is that we have no way to _enforce_
firmware signing to existing (i.e. verification-unaware) drivers if we need
an explicit call of a function, say, verify_firmware().

> and as such I've been going back and slowly
> grooming the firmware API with small atomic changes to first clean up the
> complex flag mess we have.
> 
> Since I'm busy with that Takahiro AKASHI has taken up firmware singing effort
> but this will depend on the above small cleanup to be done first. I was busy
> with addressing existing bugs on the firmware API for a while, then company
> travel / conferences so was not able to address this, but I'm back now and
> I believe I should be able to tackle the cleanup now.

Good to hear.

> Only after this is merged can we expect a final respin of the firmware signing
> effort.
> 
> > Or reflect that IMA-appraisal, if enabled, will enforce firmware being
> > validly signed.
> 
> But FWICT lockdown is a built-in kernel thingy, unless lockdown implies IMA
> it would not be the place to refer to it.

I think that the situation is the same as in module signing.

-Takahiro AKASHI

> It seems the documentation was proposed to help users if an error was caught.
> That error should cover only what is being addressed in code on the kernel.
> 
>   Luis
