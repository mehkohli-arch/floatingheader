"""Union several STL meshes into one watertight STL. usage: merge.py out.stl in1.stl in2.stl ..."""
import sys, numpy as np, trimesh, manifold3d as m3d
out, ins = sys.argv[1], sys.argv[2:]
acc = None
for fn in ins:
    t = trimesh.load(fn, force="mesh"); t.merge_vertices()
    man = m3d.Manifold(m3d.Mesh(vert_properties=np.asarray(t.vertices, np.float32), tri_verts=np.asarray(t.faces, np.uint32)))
    assert man.status() == m3d.Error.NoError, (fn, man.status())
    acc = man if acc is None else acc + man
mesh = acc.to_mesh()
r = trimesh.Trimesh(mesh.vert_properties[:, :3], mesh.tri_verts)
r.export(out)
print(f"{out}: {len(r.faces)} triangles, watertight={r.is_watertight}, bounds={np.round(r.bounds,2).tolist()}")
