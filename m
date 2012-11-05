From: Chris Friesen <chris.friesen@genband.com>
Subject: Re: [RFC] Second attempt at kernel secure boot support
Date: Mon, 05 Nov 2012 09:37:18 -0600
Message-ID: <5097DD2E.9040909@genband.com>
References: <50919EED.3020601@genband.com> <36538307.gzWq1oO7Kg@linux-lqwf.site> <1351760905.2391.19.camel@dabdike.int.hansenpartnership.com> <alpine.LNX.2.00.1211011017230.6606@pobox.suse.cz> <1351762703.2391.31.camel@dabdike.int.hansenpartnership.com> <alpine.LNX.2.00.1211011044290.6606@pobox.suse.cz> <1351763954.2391.37.camel@dabdike.int.hansenpartnership.com> <CACLa4puzLR2om6SHw3wVnfZ1nezVsKOp8+705AdHZ4_=JamYfw@mail.gmail.com> <20121101202701.GB20817@xo-6d-61-c0.localdomain> <5092E361.7080901@genband.com> <20121102154833.GG3300@redhat.com> <alpine.LNX.2.00.1211040008280.24253@pobox.suse.cz> <87390ok0zy.fsf@xmission.com> <alpine.LNX.2.00.1211051535060.24253@pobox.suse.cz> <alpine.LNX.2.00.1211051628380.24253@pobox.suse.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.LNX.2.00.1211051628380.24253@pobox.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
To: Jiri Kosina <jkosina@suse.cz>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, Vivek Goyal <vgoyal@redhat.com>, Pavel Machek <pavel@ucw.cz>, Eric Paris <eparis@parisplace.org>, James Bottomley <James.Bottomley@hansenpartnership.com>, Oliver Neukum <oneukum@suse.de>, Alan Cox <alan@lxorguk.ukuu.org.uk>, Matthew Garrett <mjg59@srcf.ucam.org>, Josh Boyer <jwboyer@gmail.com>, linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org, linux-efi@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

On 11/05/2012 09:31 AM, Jiri Kosina wrote:

> I had a naive idea of just putting in-kernel verification of a complete
> ELF binary passed to kernel by userspace, and if the signature matches,
> jumping to it.
> Would work for elf-x86_64 nicely I guess, but we'd lose a lot of other
> functionality currently being provided by kexec-tools.
>
> Bah. This is a real pandora's box.

Would it be so bad to statically link kexec?

Chris
