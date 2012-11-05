From: ebiederm@xmission.com (Eric W. Biederman)
Subject: Re: [RFC] Second attempt at kernel secure boot support
Date: Mon, 05 Nov 2012 00:50:47 -0800
Message-ID: <87k3u0cu1k.fsf@xmission.com>
References: <20121102175416.GA11816@srcf.ucam.org>
	<1351879058.2439.46.camel@dabdike.int.hansenpartnership.com>
	<20121102180458.GA12052@srcf.ucam.org>
	<1351899503.2439.49.camel@dabdike.int.hansenpartnership.com>
	<20121103002244.GC18691@srcf.ucam.org>
	<1351944236.2417.7.camel@dabdike.int.hansenpartnership.com>
	<20121103134630.GA28166@srcf.ucam.org>
	<1351983400.2417.21.camel@dabdike.int.hansenpartnership.com>
	<20121104042802.GA11295@srcf.ucam.org>
	<1352020487.2427.5.camel@dabdike.int.hansenpartnership.com>
	<20121104135251.GA17894@srcf.ucam.org> <87d2zsmv8r.fsf@xmission.com>
	<509766DB.9090906@zytor.com> <87625kh5r2.fsf@xmission.com>
	<8582ea67-beda-44e6-82cd-52d73555dda8@email.android.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <8582ea67-beda-44e6-82cd-52d73555dda8@email.android.com>
	(H. Peter Anvin's message of "Mon, 05 Nov 2012 08:40:21 +0100")
Sender: linux-security-module-owner@vger.kernel.org
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>, James Bottomley <James.Bottomley@HansenPartnership.com>, Pavel Machek <pavel@ucw.cz>, Chris Friesen <chris.friesen@genband.com>, Eric Paris <eparis@parisplace.org>, Jiri Kosina <jkosina@suse.cz>, Oliver Neukum <oneukum@suse.de>, Alan Cox <alan@lxorguk.ukuu.org.uk>, Josh Boyer <jwboyer@gmail.com>, linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org, linux-efi@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

"H. Peter Anvin" <hpa@zytor.com> writes:

> This is not a good thing to assume.  A vendor could have an external
> button, for example.

Facts are always a good thing to assume.

The fact is the general case does not admit an install without user
interaction.

It makes a lot of sense to revisit the working assumptions when for lack
of 3 o4 4 lines in the bootloader people are advocating turning gold
into lead at the cost of a national banking bailout.

Non-interactive installs are very interesting but they only make sense
in a very narrow range of cases not on every in every BIOS state on
every machine.  If the UEFI firmware will let me install a platform key
and set ever other firmware setting in my installer, then it is a good
starting state.  The rest of the time there will be some unpredictable
inconsistent mess of firmware settings that someone is going to have to
go in and fix.  Or the install cd will have blown away my existing
partitions deleting data I forgot to back up that day.

The notion that a non-interactive install is possible in the general
case is complete and total hogwash.

Eric
