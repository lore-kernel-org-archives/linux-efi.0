From: Alan Cox <gnomes@lxorguk.ukuu.org.uk>
Subject: Re: [RFC v3 PATCH 0/2] Introduce Security Version to EFI Stub
Date: Thu, 7 Dec 2017 14:26:57 +0000
Message-ID: <20171207142657.52e1363a@alans-desktop>
References: <20171205100148.5757-1-glin@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <20171205100148.5757-1-glin@suse.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Gary Lin <glin@suse.com>
Cc: linux-efi@vger.kernel.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Matt Fleming <matt@codeblueprint.co.uk>, Catalin Marinas <catalin.marinas@arm.com>, x86@kernel.org, Will Deacon <will.deacon@arm.com>, linux-kernel@vger.kernel.org, Joey Lee <jlee@suse.com>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>, linux-arm-kernel@lists.infradead.org
List-Id: linux-efi@vger.kernel.org

On Tue,  5 Dec 2017 18:01:46 +0800
Gary Lin <glin@suse.com> wrote:

> The series of patches introduce Security Version to EFI stub.
> 
> Security Version is a monotonically increasing number and designed to
> prevent the user from loading an insecure kernel accidentally. The
> bootloader maintains a list of security versions corresponding to
> different distributions. After fixing a critical vulnerability, the
> distribution kernel maintainer bumps the "version", and the bootloader
> updates the list automatically. 

This seems a mindbogglingly complicated way to implement something you
could do with a trivial script in the package that updates the list of
iffy kernels and when generating the new grub.conf puts them in a menu
of 'old insecure' kernels.

Why do you even need this in the EFI stub ?

What happens if you want to invalidate an old kernel but not push a new
one ? Today if you've got a package that maintains the list of 'iffy'
kernels you can push a tiny package, under your scheme you've got to push
new kernels which is an un-necessary and high risk OS change.

It just feels like an attempt to solve the problem in completely the
wrong place.

Alan
