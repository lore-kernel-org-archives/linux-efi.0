From: Mimi Zohar <zohar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>
Subject: Re: Firmware signing -- Re: [PATCH 00/27] security, efi: Add kernel
 lockdown
Date: Tue, 14 Nov 2017 08:17:14 -0500
Message-ID: <1510665434.3711.158.camel@linux.vnet.ibm.com>
References: <20171108194626.GQ22894@wotan.suse.de>
         <20171109014841.GF7859@linaro.org>
         <1510193857.4484.95.camel@linux.vnet.ibm.com>
         <20171109044619.GG7859@linaro.org> <20171111023240.2398ca55@alans-desktop>
         <20171113174250.GA22894@wotan.suse.de>
         <20171113210848.4dc344bd@alans-desktop>
         <454.1510609487@warthog.procyon.org.uk>
         <CA+55aFzrK29hbxoKs3GsvVUY4_uR7aBgZv2eeVyVq7MzfATY3w@mail.gmail.com>
         <1510662098.3711.139.camel@linux.vnet.ibm.com>
         <20171114123856.GA31142@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171114123856.GA31142-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Cc: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Alan Cox <gnomes-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org>, "Luis R. Rodriguez" <mcgrof-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "AKASHI, Takahiro" <takahiro.akashi-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Jan Blunck <jblunck-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Julia Lawall <julia.lawall-L2FTfq7BK8M@public.gmane.org>, Marcus Meissner <meissner-l3A5Bk7waGM@public.gmane.org>, Gary Lin <GLin-IBi9RG/b67k@public.gmane.org>, LSM List <linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-efi <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Matthew Garrett <mjg59-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Tue, 2017-11-14 at 13:38 +0100, Greg Kroah-Hartman wrote:
> On Tue, Nov 14, 2017 at 07:21:38AM -0500, Mimi Zohar wrote:
> > On Mon, 2017-11-13 at 14:09 -0800, Linus Torvalds wrote:
> > > On Mon, Nov 13, 2017 at 1:44 PM, David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
> > > >
> > > > Whilst that may be true, we either have to check signatures on every bit of
> > > > firmware that the appropriate driver doesn't say is meant to be signed or not
> > > > bother.
> > > 
> > > I vote for "not bother".
> > > 
> > > Seriously, if you have firmware in /lib/firmware, and you don't trust
> > > it, what the hell are you doing?
> > 
> > I might "trust" the files in /lib/firmware, but I also want to make
> > sure that they haven't changed.  File signatures provide file
> > provenance and integrity guarantees.
> 
> Then "verify" them with signatures that you generate yourself.  Like
> dm-verify does for the partition that you put the firmware on.

The discussion, here, is in the context of the "lockdown" patch set,
without IMA-appraisal configured.  Kernel modules and the kexec kernel
image require file signatures in lockdown mode.  An equivalent method
of requiring file signatures for firmware (without IMA-appraisal) does
not exist.

I posted the patch [RFC PATCH v2] "fw_lockdown: new micro LSM module
to prevent loading unsigned firmware".  The patch and discussion can
be found here - (https://lkml.org/lkml/2017/11/13/217).

Mimi
