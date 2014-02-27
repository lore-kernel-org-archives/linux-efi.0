From: Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH 12/12] Add option to automatically set trusted_kernel when
 in Secure Boot mode
Date: Thu, 27 Feb 2014 10:48:48 -0800
Message-ID: <CAGXu5j+dwpG=X+i9CY2U3eUsOq86sVhZDRCNoeSYjdDTDv0VbQ@mail.gmail.com>
References: <1393445473-15068-1-git-send-email-matthew.garrett@nebula.com>
	<1393445473-15068-13-git-send-email-matthew.garrett@nebula.com>
	<20140226224141.1741a746@alan.etchedpixels.co.uk>
	<1393454916.14900.54.camel@x230>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1393454916.14900.54.camel@x230>
Sender: linux-kernel-owner@vger.kernel.org
To: Matthew Garrett <matthew.garrett@nebula.com>
Cc: "gnomes@lxorguk.ukuu.org.uk" <gnomes@lxorguk.ukuu.org.uk>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "jmorris@namei.org" <jmorris@namei.org>, "hpa@zytor.com" <hpa@zytor.com>, "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>, "linux-security-module@vger.kernel.org" <linux-security-module@vger.kernel.org>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>
List-Id: linux-efi@vger.kernel.org

On Wed, Feb 26, 2014 at 2:48 PM, Matthew Garrett
<matthew.garrett@nebula.com> wrote:
> On Wed, 2014-02-26 at 22:41 +0000, One Thousand Gnomes wrote:
>> Another issue that needs addressing is firmware. Quite a few of our
>> request_firmware cases load device firmware which is not signed into DMA
>> capable hardware. Probably also worth checking what the
>> architectural guarantees on bogus microcode updates is. Maybe we need
>> firmware signing for such cases to match the mod signing ?
>
> Vendors keep telling me that they're validating firmware for new
> hardware, and I keep tending not to believe them. Meh. The big problem
> with firmware signatures is that we don't necessarily have the right to
> distribute modified versions of the firmware, so we'd need detached
> signature support. I'm certainly not against this.

I have been working on a patch series for this. It will have LSM hooks
for validating firmware origin (via fd) and contents (via blob),
similar to the changes I made for validating module origins. It just
need to finish testing, and I'll post the series. If you want to check
it out in its current state, it's here:

http://git.kernel.org/cgit/linux/kernel/git/kees/linux.git/log/?h=fw-restrict

-Kees

-- 
Kees Cook
Chrome OS Security
