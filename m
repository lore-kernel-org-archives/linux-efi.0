From: Mark Rutland <mark.rutland@arm.com>
Subject: Re: [PATCH] efi/libstub/arm*: Set default address and size cells
 values for an empty dtb
Date: Tue, 7 Feb 2017 19:06:02 +0000
Message-ID: <20170207190602.GH26173@leverpostej>
References: <1486490390-25251-1-git-send-email-jhugo@codeaurora.org>
 <CAKv+Gu963uZB4MaMDuwTGd5-AqEN53Er8tExVLMZNVx3krJrZw@mail.gmail.com>
 <1f47fcdd-c5d8-4082-70a3-ca9b1746d7ca@codeaurora.org>
 <20170207190113.GG26173@leverpostej>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
Content-Disposition: inline
In-Reply-To: <20170207190113.GG26173@leverpostej>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Jeffrey Hugo <jhugo@codeaurora.org>
Cc: Sameer Goel <sgoel@codeaurora.org>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>
List-Id: linux-efi@vger.kernel.org

On Tue, Feb 07, 2017 at 07:01:14PM +0000, Mark Rutland wrote:
> On Tue, Feb 07, 2017 at 11:54:55AM -0700, Jeffrey Hugo wrote:

> > Kexec attempts to insert these values in the fdt.  The fdt only
> > accepts 32-bit values, so it truncates what is put in.  Then later
> > kexec/kdump read the values from the fdt, and get garbage.
> 
> I take it this is specific to the kdump properties? 
> 
> I can't immediately see what would matter for the !kdump case.
> properties inserted under /chosen are not truncated?

Whoops; please ignore the last line. I'd meant to delete that (and it
obviously makes no sense).

Mark.
