From: Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: [RFC] Second attempt at kernel secure boot support
Date: Tue, 06 Nov 2012 16:55:25 -0500
Message-ID: <7c6b2e83-e49a-40aa-a990-da7599622f37@email.android.com>
References: <20121104135251.GA17894@srcf.ucam.org> <87d2zsmv8r.fsf@xmission.com> <509766DB.9090906@zytor.com> <87625kh5r2.fsf@xmission.com> <20121105123858.GB4374@srcf.ucam.org> <87sj8nc137.fsf@xmission.com> <20121105202557.GA16076@srcf.ucam.org> <87hap3zbw7.fsf@xmission.com> <20121106031219.GB24235@srcf.ucam.org> <87fw4nv1vj.fsf@xmission.com> <20121106035352.GA24698@srcf.ucam.org> <87hap3s3yl.fsf@xmission.com> <878vafqi5q.fsf@mid.deneb.enyo.de> <50992946.4060101@genband.com> <87625iwgao.fsf@mid.deneb.enyo.de>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <87625iwgao.fsf@mid.deneb.enyo.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Florian Weimer <fw@deneb.enyo.de>, Chris Friesen <chris.friesen@genband.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, "H. Peter Anvin" <hpa@zytor.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, Pavel Machek <pavel@ucw.cz>, Eric Paris <eparis@parisplace.org>, Jiri Kosina <jkosina@suse.cz>, Oliver Neukum <oneukum@suse.de>, Alan Cox <alan@lxorguk.ukuu.org.uk>, Josh Boyer <jwboyer@gmail.com>, linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org, linux-efi@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

I'm not sure why you think that Fedora PXE installs will automatically wipe disks - they'll do whatever Kickstart tells them to do. The only thing relevant to secure boot here is that you need a signed bootloader, just like when you book off CD. 
-- 
Matthew Garrett | mjg59@srcf.ucam.org
