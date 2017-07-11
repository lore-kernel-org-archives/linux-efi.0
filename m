From: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
Subject: Re: [PATCH v9 07/38] x86/mm: Remove phys_to_virt() usage in ioremap()
Date: Tue, 11 Jul 2017 10:35:17 +0200
Message-ID: <CAK8P3a3oBgE8ggAjVX6mtWKWwBmw3gYzgTqF3fh9KsQyEgL31g@mail.gmail.com>
References: <20170707133804.29711.1616.stgit@tlendack-t1.amdoffice.net>
	<20170707133925.29711.39301.stgit@tlendack-t1.amdoffice.net>
	<CAMzpN2h=AAF6OVfeGJnf5va2Msmd_BPU5BrVENvs0zGQtRMdzQ@mail.gmail.com>
	<ca43df91-163e-82ce-1d40-c17cfc90e957@amd.com>
	<CAMzpN2gq0TZbgy-3PUixwvL+6ECX5bOdE0XZsLtGFXA+-Embeg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
In-Reply-To: <CAMzpN2gq0TZbgy-3PUixwvL+6ECX5bOdE0XZsLtGFXA+-Embeg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/iommu>,
	<mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/iommu/>
List-Post: <mailto:iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/iommu>,
	<mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: Brian Gerst <brgerst-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Brijesh Singh <brijesh.singh-5C7GfCeVMHo@public.gmane.org>, Toshimitsu Kani <toshi.kani-ZPxbGqLxI0U@public.gmane.org>, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Linux-MM <linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org>, =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Alexander Potapenko <glider-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Larry Woodman <lwoodman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-arch <linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, the arch/x86 maintainers <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, kasan-dev <kasan-dev-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Andrey Ryabinin <aryabinin-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>, Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Tom Lendacky <thomas.lendacky-5C7GfCeVMHo@public.gmane.org>, Rik van Riel <riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Boris Ostrovsky <boris.ostrovsky-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Dmitry Vyukov <dvyukov-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Juer
List-Id: linux-efi@vger.kernel.org

On Tue, Jul 11, 2017 at 6:58 AM, Brian Gerst <brgerst-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> On Mon, Jul 10, 2017 at 3:50 PM, Tom Lendacky <thomas.lendacky-5C7GfCeVMHo@public.gmane.org> wrote:
>> On 7/8/2017 7:57 AM, Brian Gerst wrote:
>>> On Fri, Jul 7, 2017 at 9:39 AM, Tom Lendacky <thomas.lendacky-5C7GfCeVMHo@public.gmane.org>
>>
>> I originally had a check for SME here in a previous version of the
>> patch.  Thomas Gleixner recommended removing the check so that the code
>> path was always exercised regardless of the state of SME in order to
>> better detect issues:
>>
>> http://marc.info/?l=linux-kernel&m=149803067811436&w=2
>
> Looking a bit closer, this shortcut doesn't set the caching
> attributes.  So it's probably best to get rid of it anyways.  Also
> note, there is a corresponding check in iounmap().

Could that cause regressions if a driver relies on (write-through)
cacheable access to the VGA frame buffer RAM or an read-only
cached access to an option ROM but now gets uncached access?

I also tried to find out whether we can stop mapping the ISA MMIO
area into the linear mapping, but at least the VGA code uses
VGA_MAP_MEM() to get access to the same pointers. I'm pretty
sure this got copied incorrectly into most other architectures, but
it is definitely still used on x86 with vga16fb/vgacon/mdacon.

On the plus side, I see that removing this code path will end up
restoring MMIOTRACE support for the ISA MMIO range that was
apparently removed by accident in commit d61fc44853f4
("x86: mmiotrace, preview 2") in linux-2.6.27.

      Arnd
