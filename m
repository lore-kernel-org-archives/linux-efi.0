From: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Subject: Re: [PATCH v4 2/2] efi: an sysfs interface for user to update efi
 firmware
Date: Wed, 29 Apr 2015 14:35:04 -0700
Message-ID: <1430343304.2189.25.camel@HansenPartnership.com>
References: <20150415131906.GC21491@kroah.com>
	 <F54AEECA5E2B9541821D670476DAE19C2B8D2E74@PGSMSX102.gar.corp.intel.com>
	 <20150417134924.GB19794@kroah.com>
	 <20150417143640.GB3671@codeblueprint.co.uk>
	 <F54AEECA5E2B9541821D670476DAE19C2C279176@PGSMSX101.gar.corp.intel.com>
	 <20150420144323.GA7261@kroah.com>
	 <F54AEECA5E2B9541821D670476DAE19C2CC11869@PGSMSX102.gar.corp.intel.com>
	 <20150421075620.GA11000@kroah.com>
	 <1429665679.2207.44.camel@HansenPartnership.com>
	 <CALCETrX9GZmWnfkm-CwKW-2mPvRbNcRaY6tUY=8e0THsPBKMcA@mail.gmail.com>
	 <20150422132734.GB12062@redhat.com>
	 <1429715913.2195.22.camel@HansenPartnership.com>
	 <F54AEECA5E2B9541821D670476DAE19C2CC1259B@PGSMSX102.gar.corp.intel.com>
	 <1429798187.2170.3.camel@HansenPartnership.com>
	 <F54AEECA5E2B9541821D670476DAE19C2CC12798@PGSMSX102.gar.corp.intel.com>
	 <1429888575.2182.20.camel@HansenPartnership.com>
	 <CALCETrU2G10uGvdB6kVyfMPA=biuZwK7BAeqmKuY=jvN38K2wA@mail.gmail.com>
	 <1430174136.2314.49.camel@HansenPartnership.com>
	 <CALCETrXeh+y1XZrdDyhEmy+GK6z7-swZNPYGZybnqzppWAE+Wg@mail.gmail.com>
	 <1430175112.2314.56.camel@HansenPartnership.com>
	 <F54AEECA5E2B9541821D670476DAE19C2CC13F37@PGSMSX102.gar.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <F54AEECA5E2B9541821D670476DAE19C2CC13F37-j2khPEwRog0FyVwBAnZdSLfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Kweh, Hock Leong" <hock.leong.kweh-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Ming Lei <ming.lei-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, "Ong, Boon Leong" <boon.leong.ong-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Sam Protsenko <semen.protsenko-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Roy Franz <roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Linux FS Devel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Wed, 2015-04-29 at 11:23 +0000, Kweh, Hock Leong wrote:
> I agree with James. Due to different people may have different needs. But
> from our side, we would just like to have a simple interface for us to upload
> the efi capsule and perform update. We do not have any use case or need
> to get info from QueryCapsuleUpdate(). Let me give a suggestion here:
> please allow me to focus on deliver this simple loading interface and
> upstream it. Then later whoever has the actual use case or needs on the ioctl
> implementation, he or she could enhance base on this simple loading interface.
> What do you guys think?
> 
> Let me summarize the latest design idea:
> - No longer leverage on firmware class but use misc device
> - Do not use platform device but use device_create()
> - User just need to perform "cat file.bin > /sys/.../capsule_loader" in the shell
> - File operation functions include: open(), read(), write() and flush()
> - Perform mutex lock in open() then release the mutex in flush() for avoiding
>    race condition / concurrent loading
> - Perform the capsule update and error return at flush() function
> 
> Is there anything I missed? Any one still have concern with this idea?
> Thanks for providing the ideas as well as the review.

I think that's pretty much it.

Why don't you let me construct a straw man patch.  It's going to be a
bit controversial because it involves adding flush operations to sysfs
and kernfs, slicing apart firmware_class.c to extract the transaction
handling stuff and creating an new efi update capsule file which makes
use of it.

Once we have code, we at least have something more concrete to argue
over.

James
