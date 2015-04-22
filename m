From: One Thousand Gnomes <gnomes-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org>
Subject: Re: [PATCH v4 2/2] efi: an sysfs interface for user to update efi
 firmware
Date: Wed, 22 Apr 2015 16:24:34 +0100
Message-ID: <20150422162434.0c701702@lxorguk.ukuu.org.uk>
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
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1429715913.2195.22.camel-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Cc: Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, "Kweh, Hock Leong" <hock.leong.kweh-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Ming Lei <ming.lei-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, "Ong, Boon Leong" <boon.leong.ong-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Sam Protsenko <semen.protsenko-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Roy Franz <roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

> Yes, I think we've all agreed we can do it ... it's now a question of
> whether we can stomach the ick factor of actually initiating a
> transaction in close ... I'm still feeling queasy.

NFS does transactions - including figuring out if the data will fit - on
file close. It does that for real data so I'd relax. With hard disks we
don't even complete a set of actions on close they just float around for
a bit and get committed (but if there is a media failure you lose if you
didnt commit them first via fsync etc)

> The alternative might be a two file approach (either in sysfs or a mini
> custom fs), one for load up data and the other for initiate transaction
> with the data errors (like overflow) being returned on the load up file
> and the transaction errors being returned on the write that initiates
> the transaction.

The two file problem then turns into the "which transaction of the two
done in parallel" problem.

> My architectural sense is that transaction on close, provided we can
> make it a more universally accepted idea, has a lot of potential because
> it's more intuitive than the two file approach.

Agreed

Alan
