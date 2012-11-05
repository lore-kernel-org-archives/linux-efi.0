From: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>
Subject: Re: [RFC] Second attempt at kernel secure boot support
Date: Mon, 05 Nov 2012 08:12:27 +0100
Message-ID: <509766DB.9090906@zytor.com>
References: <20121102175416.GA11816@srcf.ucam.org> <1351879058.2439.46.camel@dabdike.int.hansenpartnership.com> <20121102180458.GA12052@srcf.ucam.org> <1351899503.2439.49.camel@dabdike.int.hansenpartnership.com> <20121103002244.GC18691@srcf.ucam.org> <1351944236.2417.7.camel@dabdike.int.hansenpartnership.com> <20121103134630.GA28166@srcf.ucam.org> <1351983400.2417.21.camel@dabdike.int.hansenpartnership.com> <20121104042802.GA11295@srcf.ucam.org> <1352020487.2427.5.camel@dabdike.int.hansenpartnership.com> <20121104135251.GA17894@srcf.ucam.org> <87d2zsmv8r.fsf@xmission.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <87d2zsmv8r.fsf-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>
Cc: Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>, James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>, Pavel Machek <pavel-+ZI9xUNit7I@public.gmane.org>, Chris Friesen <chris.friesen-b7o/lNNmKxtBDgjK7y7TUQ@public.gmane.org>, Eric Paris <eparis-FjpueFixGhCM4zKIHC2jIg@public.gmane.org>, Jiri Kosina <jkosina-AlSwsSmVLrQ@public.gmane.org>, Oliver Neukum <oneukum-l3A5Bk7waGM@public.gmane.org>, Alan Cox <alan-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org>, Josh Boyer <jwboyer-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On 11/05/2012 07:14 AM, Eric W. Biederman wrote:
> 
> In any case the notion that unattended install with no user interaction
> on any uefi machine in any state is complete and total rubbish.  It
> can't be done.  You need power and you need boot media.
> 

That is a hugely different thing from needing a console.

	-hpa
