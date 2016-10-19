From: Matt Fleming <matt@codeblueprint.co.uk>
Subject: Re: [PATCH 1/2] efi: add support for seeding the RNG from a UEFI
 config table
Date: Wed, 19 Oct 2016 12:22:43 +0100
Message-ID: <20161019112243.GD31476@codeblueprint.co.uk>
References: <1475749646-10844-1-git-send-email-ard.biesheuvel@linaro.org>
 <1475749646-10844-2-git-send-email-ard.biesheuvel@linaro.org>
 <20161019110926.GG9616@leverpostej>
 <CAKv+Gu9g1W8EfnJN2Y_Xgo=QKC1gHa95rjO32Dqt4uT+amzhnQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
Content-Disposition: inline
In-Reply-To: <CAKv+Gu9g1W8EfnJN2Y_Xgo=QKC1gHa95rjO32Dqt4uT+amzhnQ@mail.gmail.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Mark Rutland <mark.rutland@arm.com>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
List-Id: linux-efi@vger.kernel.org

On Wed, 19 Oct, at 12:13:55PM, Ard Biesheuvel wrote:
> On 19 October 2016 at 12:09, Mark Rutland <mark.rutland@arm.com> wrote:
>
> > I think to some extent this mush be treated as an ABI, given cases like
> > kexec.
> >
> 
> Perhaps, yes. That would also allow GRUB or other EFI aware
> bootloaders to generate the seed.

If we're going to go down this route, we should try and get the GUID
into the UEFI spec.
