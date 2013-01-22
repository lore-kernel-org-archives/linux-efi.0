From: Oliver Neukum <oneukum@suse.de>
Subject: Re: Fwd: 2TB USB hard drive for backing up
Date: Tue, 22 Jan 2013 12:49:52 +0100
Message-ID: <2472909.UxI1EnLDV4@linux-5eaq.site>
References: <jmunm9$90r$2@speranza.aioe.org> <CAGZeNoeEoecpjvuP9uwphostOcrrAJNerxYGUtjyaMEBn04jxQ@mail.gmail.com> <1358852735.2387.34.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <1358852735.2387.34.camel@dabdike.int.hansenpartnership.com>
Sender: linux-scsi-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: Ellwood Blues <elwood.blue@gmail.com>, linux-efi@vger.kernel.org, linux-scsi <linux-scsi@vger.kernel.org>, USB Storage List <usb-storage@lists.one-eyed-alien.net>
List-Id: linux-efi@vger.kernel.org

On Tuesday 22 January 2013 11:05:35 James Bottomley wrote:
> > May  3 18:19:06 relampago3 kernel: [ 3948.472796] sd 7:0:0:0: [sdf]
> > 1565565872 512-byte logical blocks: (801 GB/746 GiB)
> 
> This looks like a wrap around of your actual size.  This appears to
> indicate the device isn't replying correctly to READ CAPACITY.  The
> conventional return from READ CAPACITY should be -1 which would trigger
> us to retry with READ CAPACITY(16).

What can we do? The answer the device is giving is quite ordinary.
Do we need another quirk and an associated flag?

	Regards
		Oliver

